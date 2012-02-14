module ActiveRecordCache
  module Base
    
    def self.included(base)
      base.class_eval do
        
        class_attribute :use_activerecord_cache, :instance_writer => false
        self.use_activerecord_cache = false
        
        extend ActiveRecordCache::Base::CacheMethods
        
      end
    end
    
    module CacheMethods
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
        
        "#{name}:#{id}"
      end
      
      def find_through_cache(id)
        unless use_activerecord_cache
          message = "ActiveRecord cache is not enabled for #{self.name}"
          raise ActiveRecordCache::CachingNotEnabled, message
        end

        Rails.cache.fetch(cache_key(id)) { where(primary_key => id).first }
      end
      
      def write_to_cache(record)
        unless use_activerecord_cache
          message = "ActiveRecord cache is not enabled for #{self.name}"
          raise ActiveRecordCache::CachingNotEnabled, message
        end
        
        unless record.class == self
          message = "Instance of #{self} expected, got #{record.class}"
          raise ActiveRecordCache::RecordTypeMismatch, message
        end
        
        Rails.cache.write(cache_key(record), record)
      end
      
    end
    
  end
end
