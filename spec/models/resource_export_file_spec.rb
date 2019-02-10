require 'rails_helper'
  
describe ResourceExportFile do
  fixtures :all
  
  it "should export NCID value" do
    manifestation = FactoryBot.create(:manifestation)
    ncid_record = NcidRecord.create(body: "BA91833159", manifestation: manifestation)
    export_file = ResourceExportFile.new
    export_file.user = users(:admin)
    export_file.save!
    export_file.export!
    file = export_file.resource_export
    expect(file).to be_truthy
    lines = StringIO.new(file.download).readlines.map(&:chomp)
    expect(lines.find{|line| line =~ /ncid/}).to be_truthy
    expect(lines.find{|line| line =~ /BA91833159/}).to be_truthy
  end
end
