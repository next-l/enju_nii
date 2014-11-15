class RemoveNcidFromManifestations < ActiveRecord::Migration
  def change
    remove_column :manifestations, :ncid, :string
  end
end
