class NonPrimaryAssociated < ActiveRecord::Base
  belongs_to :cached_record, foreign_key: :name, primary_key: :name
end
