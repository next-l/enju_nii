require 'rails_helper'

describe "manifestations/show" do
  fixtures :all

  before(:each) do
    assign(:manifestation, FactoryBot.create(:manifestation))
    allow(view).to receive(:policy).and_return double(create?: false, udpate?: false, destroy?: false)
  end

  describe "identifier_link" do
    it "renders a link to CiNii Books" do
      assign(:manifestation, manifestations(:manifestation_00217))
      render
      rendered.should include '<a href="https://ci.nii.ac.jp/ncid/BN15603730">BN15603730</a>'
    end
  end
end
