require 'spec_helper'

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

describe LopMonHocsController do

  # This should return the minimal set of attributes required to create a valid
  # LopMonHoc. As you add validations to LopMonHoc, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "ma_lop" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LopMonHocsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all lop_mon_hocs as @lop_mon_hocs" do
      lop_mon_hoc = LopMonHoc.create! valid_attributes
      get :index, {}, valid_session
      assigns(:lop_mon_hocs).should eq([lop_mon_hoc])
    end
  end

  describe "GET show" do
    it "assigns the requested lop_mon_hoc as @lop_mon_hoc" do
      lop_mon_hoc = LopMonHoc.create! valid_attributes
      get :show, {:id => lop_mon_hoc.to_param}, valid_session
      assigns(:lop_mon_hoc).should eq(lop_mon_hoc)
    end
  end

  describe "GET new" do
    it "assigns a new lop_mon_hoc as @lop_mon_hoc" do
      get :new, {}, valid_session
      assigns(:lop_mon_hoc).should be_a_new(LopMonHoc)
    end
  end

  describe "GET edit" do
    it "assigns the requested lop_mon_hoc as @lop_mon_hoc" do
      lop_mon_hoc = LopMonHoc.create! valid_attributes
      get :edit, {:id => lop_mon_hoc.to_param}, valid_session
      assigns(:lop_mon_hoc).should eq(lop_mon_hoc)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new LopMonHoc" do
        expect {
          post :create, {:lop_mon_hoc => valid_attributes}, valid_session
        }.to change(LopMonHoc, :count).by(1)
      end

      it "assigns a newly created lop_mon_hoc as @lop_mon_hoc" do
        post :create, {:lop_mon_hoc => valid_attributes}, valid_session
        assigns(:lop_mon_hoc).should be_a(LopMonHoc)
        assigns(:lop_mon_hoc).should be_persisted
      end

      it "redirects to the created lop_mon_hoc" do
        post :create, {:lop_mon_hoc => valid_attributes}, valid_session
        response.should redirect_to(LopMonHoc.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved lop_mon_hoc as @lop_mon_hoc" do
        # Trigger the behavior that occurs when invalid params are submitted
        LopMonHoc.any_instance.stub(:save).and_return(false)
        post :create, {:lop_mon_hoc => { "ma_lop" => "invalid value" }}, valid_session
        assigns(:lop_mon_hoc).should be_a_new(LopMonHoc)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        LopMonHoc.any_instance.stub(:save).and_return(false)
        post :create, {:lop_mon_hoc => { "ma_lop" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested lop_mon_hoc" do
        lop_mon_hoc = LopMonHoc.create! valid_attributes
        # Assuming there are no other lop_mon_hocs in the database, this
        # specifies that the LopMonHoc created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        LopMonHoc.any_instance.should_receive(:update_attributes).with({ "ma_lop" => "MyString" })
        put :update, {:id => lop_mon_hoc.to_param, :lop_mon_hoc => { "ma_lop" => "MyString" }}, valid_session
      end

      it "assigns the requested lop_mon_hoc as @lop_mon_hoc" do
        lop_mon_hoc = LopMonHoc.create! valid_attributes
        put :update, {:id => lop_mon_hoc.to_param, :lop_mon_hoc => valid_attributes}, valid_session
        assigns(:lop_mon_hoc).should eq(lop_mon_hoc)
      end

      it "redirects to the lop_mon_hoc" do
        lop_mon_hoc = LopMonHoc.create! valid_attributes
        put :update, {:id => lop_mon_hoc.to_param, :lop_mon_hoc => valid_attributes}, valid_session
        response.should redirect_to(lop_mon_hoc)
      end
    end

    describe "with invalid params" do
      it "assigns the lop_mon_hoc as @lop_mon_hoc" do
        lop_mon_hoc = LopMonHoc.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        LopMonHoc.any_instance.stub(:save).and_return(false)
        put :update, {:id => lop_mon_hoc.to_param, :lop_mon_hoc => { "ma_lop" => "invalid value" }}, valid_session
        assigns(:lop_mon_hoc).should eq(lop_mon_hoc)
      end

      it "re-renders the 'edit' template" do
        lop_mon_hoc = LopMonHoc.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        LopMonHoc.any_instance.stub(:save).and_return(false)
        put :update, {:id => lop_mon_hoc.to_param, :lop_mon_hoc => { "ma_lop" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested lop_mon_hoc" do
      lop_mon_hoc = LopMonHoc.create! valid_attributes
      expect {
        delete :destroy, {:id => lop_mon_hoc.to_param}, valid_session
      }.to change(LopMonHoc, :count).by(-1)
    end

    it "redirects to the lop_mon_hocs list" do
      lop_mon_hoc = LopMonHoc.create! valid_attributes
      delete :destroy, {:id => lop_mon_hoc.to_param}, valid_session
      response.should redirect_to(lop_mon_hocs_url)
    end
  end

end