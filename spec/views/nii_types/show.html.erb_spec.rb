require 'rails_helper'

RSpec.describe "nii_types/show", type: :view do
  before(:each) do
    @nii_type = assign(:nii_type, NiiType.create!(name: 'test'))
  end

  it "renders attributes in <p>" do
    render
  end
end
