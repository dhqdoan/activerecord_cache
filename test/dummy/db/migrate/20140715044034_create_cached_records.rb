class CreateCachedRecords < ActiveRecord::Migration
  def change
    create_table :cached_records do |t|
      t.string :name

      t.timestamps
    end
  end
end
