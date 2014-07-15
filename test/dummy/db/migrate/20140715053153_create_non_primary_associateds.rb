class CreateNonPrimaryAssociateds < ActiveRecord::Migration
  def change
    create_table :non_primary_associateds do |t|
      t.string :name

      t.timestamps
    end
  end
end
