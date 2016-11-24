require 'rails_helper'

RSpec.describe "nii_types/new", type: :view do
  before(:each) do
    assign(:nii_type, NiiType.new())
  end

  it "renders new nii_type form" do
    render

    assert_select "form[action=?][method=?]", nii_types_path, "post" do
    end
  end
end
