module ActiveRecordCache
  module BelongsToPreloader
    extend ActiveSupport::Concern
    
    included do
      alias_method_chain :records_for, :caching
    end
    
    
    module InstanceMethods
      
      def records_for_with_caching(ids)
        if klass.use_activerecord_cache && association_key.name == klass.primary_key
          klass.find_some_through_cache(ids)
        else
          records_for_without_caching(ids) 
        end
      end
      
    end
    
  end
end