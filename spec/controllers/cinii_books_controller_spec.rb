require 'spec_helper'

describe CiniiBooksController do
  fixtures :all

  it "should be a kind of enju_nii" do
    assert_kind_of Module, EnjuNii
  end

  describe "GET index" do
    login_fixture_admin
    use_vcr_cassette "enju_nii/search", :record => :new_episodes

    it "should get index" do
      get :index, :query => 'library'
      assigns(:books).should_not be_empty
    end

    it "should be empty if a query is not set" do
      get :index
      assigns(:books).should be_empty
    end
  end
end
