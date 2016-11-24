require "rails_helper"

RSpec.describe NiiTypesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/nii_types").to route_to("nii_types#index")
    end

    it "routes to #new" do
      expect(:get => "/nii_types/new").to route_to("nii_types#new")
    end

    it "routes to #show" do
      expect(:get => "/nii_types/1").to route_to("nii_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/nii_types/1/edit").to route_to("nii_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/nii_types").to route_to("nii_types#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/nii_types/1").to route_to("nii_types#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/nii_types/1").to route_to("nii_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/nii_types/1").to route_to("nii_types#destroy", :id => "1")
    end

  end
end
