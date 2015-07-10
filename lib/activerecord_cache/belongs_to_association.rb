module ActiveRecordCache
  module BelongsToAssociation
    extend ActiveSupport::Concern

    included do
      alias_method_chain :find_target, :caching
    end

    private

    def find_target_with_caching
      if klass.use_activerecord_cache && reflection.options[:primary_key].nil?
        klass.find_through_cache(owner[reflection.foreign_key]).tap do |record|
          # Do not pre-load inverse association_cache for polymorphic association to avoid issues on Rails 4.2.1+
          set_inverse_instance(record) if reflection.inverse_of.nil? || reflection.inverse_of.options[:as].nil?
        end
      else
        find_target_without_caching
      end
    end
  end
end
