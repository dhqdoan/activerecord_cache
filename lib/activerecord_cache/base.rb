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
          raise ActiveRecordCache::CachingNotEnabled, message
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

        Rails.cache.read(cache_key(id)) || where(primary_key => id).first
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
          records += where(primary_key => cache_misses).all
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
    
    module InstanceMethods

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
end
