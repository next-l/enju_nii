require 'rails_helper'
  
describe ResourceImportFile do
  fixtures :all
  
  describe "when its mode is 'create'" do
    describe "NCID import" do
      it "should import ncid value" do
        file = ResourceImportFile.new(
          user: users(:admin),
          default_shelf_id: 3,
          edit_mode: 'create'
        )
        file.attachment.attach(io: StringIO.new("original_title\tncid\noriginal_title_ncid\tBA67656964\n"), filename: 'attachment.txt')
        file.save!
        result = file.import_start
        expect(result[:manifestation_created]).to eq 1
        resource_import_result = file.resource_import_results.last
        resource_import_result.item.save!
        expect(resource_import_result.error_message).to be_blank
        expect(resource_import_result.manifestation).not_to be_blank
        manifestation = resource_import_result.manifestation
        expect(manifestation.ncid_record.body).to eq "BA67656964"
      end
    end
  end

  describe "when its mode is 'update'" do
    describe "NCID import" do
      it "should import ncid value" do
        file = ResourceImportFile.new(
          user: users(:admin),
          edit_mode: 'update'
        )
        file.attachment.attach(io: StringIO.new("manifestation_id\tncid\n1\tBA67656964\n"), filename: 'attachment.txt')
        file.save
        result = file.import_start
        expect(result[:manifestation_updated]).to eq 1
        expect(file.error_message).to be_nil
        resource_import_result = file.resource_import_results.last
        expect(resource_import_result.error_message).to be_blank
        expect(resource_import_result.manifestation).not_to be_blank
        manifestation = resource_import_result.manifestation
        expect(manifestation.ncid_record.body).to eq "BA67656964"
      end
    end
  end
end

# == Schema Information
#
# Table name: resource_import_files
#
#  id                          :bigint           not null, primary key
#  user_id                     :bigint
#  note                        :text
#  executed_at                 :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  edit_mode                   :string
#  resource_import_fingerprint :string
#  error_message               :text
#  user_encoding               :string
#  default_shelf_id            :integer
#
