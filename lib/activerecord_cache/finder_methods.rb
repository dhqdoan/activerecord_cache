module ActiveRecordCache
  module FinderMethods
    
    def self.included(base)
      base.module_eval do
        alias_method_chain :find_by_attributes, :caching
        alias_method_chain :find_some, :caching
        alias_method_chain :find_one, :caching
      end
    end
    
  protected

    def find_by_attributes_with_caching(match, attributes, *args)
      unless cached_lookup_allowed? && attributes == Array(@klass.primary_key) # must only be finding by primary key
        return find_by_attributes_without_caching(match, attributes, *args)
      end
      
      ids = Array(args.first)
      
      results = case match.finder
      when :all   then ids.map {|id| @klass.find_through_cache(id)}.compact
      when :first then @klass.find_through_cache(ids.first)
      when :last  then @klass.find_through_cache(ids.last)
      end
      
      results
    end
    
    
    def find_some_with_caching(ids)
      return find_some_without_caching(ids) unless cached_lookup_allowed?
      
      results = ids.map {|id| @klass.find_through_cache(id)}.compact
      
      if results.size != ids.size
        error = "Couldn't find all #{@klass.name.pluralize} with IDs "
        error << "(#{ids.join(", ")}) (found #{result.size} results, but was looking for #{ids.size})"
        raise ActiveRecord::RecordNotFound, error
      end
      
      results
    end
    
    
    def find_one_with_caching(id)
      return find_one_without_caching(id) unless cached_lookup_allowed?
      
      record = @klass.find_through_cache(id)
      
      unless record
        raise ActiveRecord::RecordNotFound, "Couldn't find #{@klass.name} with #{primary_key}=#{id}"
      end
      
      record
    end
    
    
    # only support the most basic lookups through the cache
    def cached_lookup_allowed?
      @klass.use_activerecord_cache && arel.where_sql.nil? && @limit_value.nil? && @offset_value.nil?
    end
    
  end
end