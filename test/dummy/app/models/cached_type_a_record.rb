class CachedTypeARecord < ActiveRecord::Base
  self.use_activerecord_cache = true

  has_one :poly_record, :as => :detail
end