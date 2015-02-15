module ActiveRecordCache
  module Core

    def find(*args)
      # Only handle single integer ids
      return super(*args) unless use_activerecord_cache && args.length == 1 && !args.first.kind_of?(Array)

      id = args.first
      record = find_through_cache(id)

      unless record
        raise ActiveRecord::RecordNotFound, "Couldn't find #{name} with '#{primary_key}'=#{id}"
      end

      record
    end

  end
end
