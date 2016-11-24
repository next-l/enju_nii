require 'rails_helper'

RSpec.describe "nii_types/edit", type: :view do
  before(:each) do
    @nii_type = assign(:nii_type, NiiType.create!(name: 'test'))
  end

  it "renders the edit nii_type form" do
    render

    assert_select "form[action=?][method=?]", nii_type_path(@nii_type), "post" do
    end
  end
end
