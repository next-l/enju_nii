require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe NiiTypesController do
  fixtures :all
  login_fixture_admin

  # This should return the minimal set of attributes required to create a valid
  # NiiType. As you add validations to NiiType, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {name: 'test'}
  end

  describe "GET index" do
    it "assigns all nii_types as @nii_types" do
      nii_type = NiiType.create! valid_attributes
      get :index
      expect(assigns(:nii_types)).to eq(NiiType.order(:position))
    end
  end

  describe "GET show" do
    it "assigns the requested nii_type as @nii_type" do
      nii_type = NiiType.create! valid_attributes
      get :show, :id => nii_type.id
      expect(assigns(:nii_type)).to eq(nii_type)
    end
  end

  describe "GET new" do
    it "assigns a new nii_type as @nii_type" do
      get :new
      expect(assigns(:nii_type)).to be_a_new(NiiType)
    end
  end

  describe "GET edit" do
    it "assigns the requested nii_type as @nii_type" do
      nii_type = NiiType.create! valid_attributes
      get :edit, :id => nii_type.id
      expect(assigns(:nii_type)).to eq(nii_type)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new NiiType" do
        expect {
          post :create, :nii_type => valid_attributes
        }.to change(NiiType, :count).by(1)
      end

      it "assigns a newly created nii_type as @nii_type" do
        post :create, :nii_type => valid_attributes
        expect(assigns(:nii_type)).to be_a(NiiType)
        expect(assigns(:nii_type)).to be_persisted
      end

      it "redirects to the created nii_type" do
        post :create, :nii_type => valid_attributes
        expect(response).to redirect_to(NiiType.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved nii_type as @nii_type" do
        # Trigger the behavior that occurs when invalid params are submitted
        NiiType.any_instance.stub(:save).and_return(false)
        post :create, :nii_type => {name: "test"}
        expect(assigns(:nii_type)).to be_a_new(NiiType)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        NiiType.any_instance.stub(:save).and_return(false)
        post :create, :nii_type => {name: "test"}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested nii_type" do
        nii_type = NiiType.create! valid_attributes
        # Assuming there are no other nii_types in the database, this
        # specifies that the NiiType created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        NiiType.any_instance.should_receive(:update_attributes).with({'name' => 'test'})
        put :update, :id => nii_type.id, :nii_type => {'name' => 'test'}
      end

      it "assigns the requested nii_type as @nii_type" do
        nii_type = NiiType.create! valid_attributes
        put :update, :id => nii_type.id, :nii_type => valid_attributes
        expect(assigns(:nii_type)).to eq(nii_type)
      end

      it "redirects to the nii_type" do
        nii_type = NiiType.create! valid_attributes
        put :update, :id => nii_type.id, :nii_type => valid_attributes
        expect(response).to redirect_to(nii_type)
      end

      it "moves its position when specified" do
        nii_type = NiiType.create! valid_attributes
        position = nii_type.position
        put :update, :id => nii_type.id, :move => 'higher'
        expect(response).to redirect_to nii_types_url
        assigns(:nii_type).reload.position.should eq position - 1
      end
    end

    describe "with invalid params" do
      it "assigns the nii_type as @nii_type" do
        nii_type = NiiType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        NiiType.any_instance.stub(:save).and_return(false)
        put :update, :id => nii_type.id, :nii_type => {name: "test"}
        expect(assigns(:nii_type)).to eq(nii_type)
      end

      it "re-renders the 'edit' template" do
        nii_type = NiiType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        NiiType.any_instance.stub(:save).and_return(false)
        put :update, :id => nii_type.id, :nii_type => {name: "test"}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested nii_type" do
      nii_type = NiiType.create! valid_attributes
      expect {
        delete :destroy, :id => nii_type.id
      }.to change(NiiType, :count).by(-1)
    end

    it "redirects to the nii_types list" do
      nii_type = NiiType.create! valid_attributes
      delete :destroy, :id => nii_type.id
      expect(response).to redirect_to(nii_types_url)
    end
  end

end
