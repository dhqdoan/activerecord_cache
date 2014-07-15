class AssociatedRecord < ActiveRecord::Base
  belongs_to :cached_record
end
