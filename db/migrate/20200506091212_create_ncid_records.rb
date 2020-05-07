class CreateNcidRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :ncid_records do |t|
      t.references :manifestation, null: false, foreign_key: true
      t.string :body, null: false, index: {unique: true}

      t.timestamps
    end
  end
end
