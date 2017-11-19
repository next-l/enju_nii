class AddNiiTypeIdToManifestation < ActiveRecord::Migration[5.1]
  def change
    add_reference :manifestations, :nii_type, foreign_key: true
  end
end
