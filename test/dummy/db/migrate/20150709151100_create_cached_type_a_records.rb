class CreateCachedTypeARecords < ActiveRecord::Migration
  def change
    create_table :cached_type_a_records do |t|
      t.string :name

      t.timestamps
    end
  end
end