class CreateAssociatedRecords < ActiveRecord::Migration
  def change
    create_table :associated_records do |t|
      t.references :cached_record

      t.timestamps
    end
    add_index :associated_records, :cached_record_id
  end
end
