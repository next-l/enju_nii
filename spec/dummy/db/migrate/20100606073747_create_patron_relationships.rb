class CreatePatronRelationships < ActiveRecord::Migration
  def change
    create_table :patron_relationships do |t|
      t.integer :parent_id
      t.integer :child_id
      t.integer :patron_relationship_type_id

      t.timestamps
    end
    add_index :patron_relationships, :parent_id
    add_index :patron_relationships, :child_id
  end
end
