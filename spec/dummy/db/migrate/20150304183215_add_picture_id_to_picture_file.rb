class AddPictureIdToPictureFile < ActiveRecord::Migration[5.1]
  def change
    add_column :picture_files, :picture_id, :string
    rename_column :picture_files, :picture_file_size, :picture_size
    add_index :picture_files, :picture_id
  end
end
