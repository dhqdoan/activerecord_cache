class CreatePolyRecords < ActiveRecord::Migration
  def change
    create_table :poly_records do |t|
      t.string :name
      t.references :detail, polymorphic: true, index: true
      t.references :cached_type_b_record
      t.references :cached_type_a_record
      t.timestamps
    end
  end
end
