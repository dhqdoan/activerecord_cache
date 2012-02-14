module ActiveRecordCache
  module BelongsToAssociation
    
    def self.included(base)
      base.class_eval do
        alias_method_chain :find_target, :caching
      end
    end

  protected

    def find_target_with_caching
      if klass.use_activerecord_cache
        klass.find_through_cache(owner[reflection.foreign_key])
      else
        find_target_without_caching
      end
    end
    
  end
end