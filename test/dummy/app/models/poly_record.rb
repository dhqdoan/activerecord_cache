class PolyRecord < ActiveRecord::Base
  self.use_activerecord_cache = true

  belongs_to :detail, :polymorphic => true, :dependent => :destroy
  belongs_to :cached_type_b_record
  belongs_to :cached_type_a_record
end