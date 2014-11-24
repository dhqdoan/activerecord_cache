module ActiveRecordCache
  module Base
    extend ActiveSupport::Concern

    included do
      class_attribute :use_activerecord_cache, :instance_writer => false
      self.use_activerecord_cache = false

      after_save    :write_to_cache,    :if => lambda { self.class.use_activerecord_cache }
      after_destroy :delete_from_cache, :if => lambda { self.class.use_activerecord_cache }
    end

    module ClassMethods
      def cache_key(id_or_record)
        unless use_activerecord_cache
          message = "ActiveRecord cache is not enabled for #{self.name}"
          raise ActiveRecordCache::CacheNotEnabled, message
        end

        if id_or_record.is_a?(ActiveRecord::Base)
          id = id_or_record[id_or_record.class.primary_key]
        else
          id = id_or_record
        end

        "#{model_name}/#{id}"
      end

      def find_through_cache(id)
        unless use_activerecord_cache
          message = "ActiveRecord cache is not enabled for #{self.name}"
          raise ActiveRecordCache::CacheNotEnabled, message
        end

        record = Rails.cache.read(cache_key(id))

        unless record
          # use where to bypass cached finders
          record = where(primary_key => id).first
          record.write_to_cache if record
        end

        record
      end

      def find_some_through_cache(ids)
        unless use_activerecord_cache
          message = "ActiveRecord cache is not enabled for #{self.name}"
          raise ActiveRecordCache::CacheNotEnabled, message
        end

        records = []
        cache_misses = []

        ids.each do |id|
          if record = find_in_cache(id)
            records << record
          else
            cache_misses << id
          end
        end

        if cache_misses.present?
          # use where to bypass cached finders
          loaded_records = where(primary_key => cache_misses).load

          loaded_records.each(&:write_to_cache)

          records += loaded_records
        end

        records
      end

      def find_in_cache(id)
        unless use_activerecord_cache
          message = "ActiveRecord cache is not enabled for #{self.name}"
          raise ActiveRecordCache::CacheNotEnabled, message
        end

        Rails.cache.read(cache_key(id))
      end

    end

    def write_to_cache
      unless self.class.use_activerecord_cache
        message = "ActiveRecord cache is not enabled for #{self.class.name}"
        raise ActiveRecordCache::CacheNotEnabled, message
      end

      Rails.cache.write(self.class.cache_key(self), self)
    end

    def delete_from_cache
      Rails.cache.delete(self.class.cache_key(self))
    end
  end
end
