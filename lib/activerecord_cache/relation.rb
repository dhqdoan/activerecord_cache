module ActiveRecordCache
  module Relation
    extend ActiveSupport::Concern

    included do
      alias_method_chain :exec_queries, :caching
    end

    def exec_queries_with_caching
      records = exec_queries_without_caching
      records.each(&:write_to_cache) if @klass.use_activerecord_cache && select_values.empty?

      records
    end
  end
end
