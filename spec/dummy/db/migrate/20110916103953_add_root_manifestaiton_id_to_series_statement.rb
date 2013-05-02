class AddRootManifestaitonIdToSeriesStatement < ActiveRecord::Migration
  def self.up
    add_column :series_statements, :root_manifestation_id, :integer
    add_index :series_statements, :root_manifestation_id
  end

  def self.down
    remove_column :series_statements, :root_manifestation_id
  end
end
