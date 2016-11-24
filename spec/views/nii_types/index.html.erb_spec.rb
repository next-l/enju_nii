require 'rails_helper'

RSpec.describe "nii_types/index", type: :view do
  before(:each) do
    assign(:nii_types, [
      NiiType.create!(name: 'test1'),
      NiiType.create!(name: 'test2')
    ])
  end

  it "renders a list of nii_types" do
    allow(view).to receive(:policy).and_return double(create?: true, update?: true, destroy?: true)
    render
  end
end
