require 'rails_helper'
  
describe ResourceExportFile do
  fixtures :all

  it "should export custom identifier's value" do
    export_file = ResourceExportFile.new
    export_file.user = users(:admin)
    export_file.save!
    export_file.export!
    file = export_file.attachment
    expect(file).to be_truthy
    lines = file.download.split("\n")
    expect(lines.first.split(/\t/)).to include "ncid"
    expect(lines.last.split(/\t/)).to include "BN15603730"
  end
end 
