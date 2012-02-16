module ActiveRecordCache
  module FinderMethods
    extend ActiveSupport::Concern
    
    included do
      alias_method_chain :find_by_attributes, :caching
      alias_method_chain :find_some, :caching
      alias_method_chain :find_one, :caching
    end

    module InstanceMethods
      
    protected
      
      def find_by_attributes_with_caching(match, attributes, *args)
        unless cached_lookup_allowed? && attributes == Array(@klass.primary_key) && (match.finder == :all || !args.first.is_a?(Array))
          return find_by_attributes_without_caching(match, attributes, *args)
        end
        
        param = args.first
      
        results = case match.finder
        when :all   then @klass.find_some_through_cache(Array(param))
        when :first then @klass.find_through_cache(param)
        when :last  then @klass.find_through_cache(param)
        end
      
        results
      end
    
    
      def find_some_with_caching(ids)
        return find_some_without_caching(ids) unless cached_lookup_allowed?
      
        results = find_some_through_cache(ids)

        if results.size != ids.size
          error = "Couldn't find all #{@klass.name.pluralize} with IDs "
          error << "(#{ids.join(", ")}) (found #{results.size} results, but was looking for #{ids.size})"
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
        @klass.use_activerecord_cache && arel.where_sql.nil? && arel.join_sql.nil? && @limit_value.nil? && @offset_value.nil?
      end
      
    end
    
  end
end