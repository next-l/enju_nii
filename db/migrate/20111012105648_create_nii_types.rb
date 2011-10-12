class CreateNiiTypes < ActiveRecord::Migration
  def change
    create_table :nii_types do |t|
      t.string :name, :null => false
      t.string :display_name
      t.text :note
      t.integer :position

      t.timestamps
    end
  end
end
