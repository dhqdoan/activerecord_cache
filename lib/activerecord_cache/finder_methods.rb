module ActiveRecordCache
  module FinderMethods
    extend ActiveSupport::Concern

    included do
      alias_method_chain :find_some, :caching
      alias_method_chain :find_one, :caching
    end

    protected

    def find_some_with_caching(ids)
      return find_some_without_caching(ids) unless cached_lookup_allowed?

      results = find_some_through_cache(ids)

      raise_record_not_found_exception!(ids, result.size, ids.size) unless results.size == ids.size

      results
    end

    def find_one_with_caching(id)
      return find_one_without_caching(id) unless cached_lookup_allowed?

      record = find_through_cache(id)

      raise_record_not_found_exception!(id, 0, 1) unless record

      record
    end

    # only support the most basic lookups through the cache
    def cached_lookup_allowed?
      @klass.use_activerecord_cache && arel.where_sql.nil? && arel.join_sql.nil? && @limit_value.nil? && @offset_value.nil?
    end
  end
end
