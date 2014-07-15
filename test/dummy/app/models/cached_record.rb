class CachedRecord < ActiveRecord::Base
  self.use_activerecord_cache = true
end
