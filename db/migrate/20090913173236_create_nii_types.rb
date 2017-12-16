class CreateNiiTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :nii_types do |t|
      t.string :name, null: false, index: {unique: true}
      t.text :display_name
      t.text :note
      t.integer :position

      t.timestamps
    end
  end
end
