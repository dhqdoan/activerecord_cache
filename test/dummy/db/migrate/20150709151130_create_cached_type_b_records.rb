class CreateCachedTypeBRecords < ActiveRecord::Migration
  def change
    create_table :cached_type_b_records do |t|
      t.string :name

      t.timestamps
    end
  end
end