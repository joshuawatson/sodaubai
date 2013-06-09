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

describe DiemChuyenCansController do

  # This should return the minimal set of attributes required to create a valid
  # DiemChuyenCan. As you add validations to DiemChuyenCan, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "ma_sinh_vien" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DiemChuyenCansController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all diem_chuyen_cans as @diem_chuyen_cans" do
      diem_chuyen_can = DiemChuyenCan.create! valid_attributes
      get :index, {}, valid_session
      assigns(:diem_chuyen_cans).should eq([diem_chuyen_can])
    end
  end

  describe "GET show" do
    it "assigns the requested diem_chuyen_can as @diem_chuyen_can" do
      diem_chuyen_can = DiemChuyenCan.create! valid_attributes
      get :show, {:id => diem_chuyen_can.to_param}, valid_session
      assigns(:diem_chuyen_can).should eq(diem_chuyen_can)
    end
  end

  describe "GET new" do
    it "assigns a new diem_chuyen_can as @diem_chuyen_can" do
      get :new, {}, valid_session
      assigns(:diem_chuyen_can).should be_a_new(DiemChuyenCan)
    end
  end

  describe "GET edit" do
    it "assigns the requested diem_chuyen_can as @diem_chuyen_can" do
      diem_chuyen_can = DiemChuyenCan.create! valid_attributes
      get :edit, {:id => diem_chuyen_can.to_param}, valid_session
      assigns(:diem_chuyen_can).should eq(diem_chuyen_can)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new DiemChuyenCan" do
        expect {
          post :create, {:diem_chuyen_can => valid_attributes}, valid_session
        }.to change(DiemChuyenCan, :count).by(1)
      end

      it "assigns a newly created diem_chuyen_can as @diem_chuyen_can" do
        post :create, {:diem_chuyen_can => valid_attributes}, valid_session
        assigns(:diem_chuyen_can).should be_a(DiemChuyenCan)
        assigns(:diem_chuyen_can).should be_persisted
      end

      it "redirects to the created diem_chuyen_can" do
        post :create, {:diem_chuyen_can => valid_attributes}, valid_session
        response.should redirect_to(DiemChuyenCan.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved diem_chuyen_can as @diem_chuyen_can" do
        # Trigger the behavior that occurs when invalid params are submitted
        DiemChuyenCan.any_instance.stub(:save).and_return(false)
        post :create, {:diem_chuyen_can => { "ma_sinh_vien" => "invalid value" }}, valid_session
        assigns(:diem_chuyen_can).should be_a_new(DiemChuyenCan)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        DiemChuyenCan.any_instance.stub(:save).and_return(false)
        post :create, {:diem_chuyen_can => { "ma_sinh_vien" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested diem_chuyen_can" do
        diem_chuyen_can = DiemChuyenCan.create! valid_attributes
        # Assuming there are no other diem_chuyen_cans in the database, this
        # specifies that the DiemChuyenCan created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        DiemChuyenCan.any_instance.should_receive(:update_attributes).with({ "ma_sinh_vien" => "MyString" })
        put :update, {:id => diem_chuyen_can.to_param, :diem_chuyen_can => { "ma_sinh_vien" => "MyString" }}, valid_session
      end

      it "assigns the requested diem_chuyen_can as @diem_chuyen_can" do
        diem_chuyen_can = DiemChuyenCan.create! valid_attributes
        put :update, {:id => diem_chuyen_can.to_param, :diem_chuyen_can => valid_attributes}, valid_session
        assigns(:diem_chuyen_can).should eq(diem_chuyen_can)
      end

      it "redirects to the diem_chuyen_can" do
        diem_chuyen_can = DiemChuyenCan.create! valid_attributes
        put :update, {:id => diem_chuyen_can.to_param, :diem_chuyen_can => valid_attributes}, valid_session
        response.should redirect_to(diem_chuyen_can)
      end
    end

    describe "with invalid params" do
      it "assigns the diem_chuyen_can as @diem_chuyen_can" do
        diem_chuyen_can = DiemChuyenCan.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DiemChuyenCan.any_instance.stub(:save).and_return(false)
        put :update, {:id => diem_chuyen_can.to_param, :diem_chuyen_can => { "ma_sinh_vien" => "invalid value" }}, valid_session
        assigns(:diem_chuyen_can).should eq(diem_chuyen_can)
      end

      it "re-renders the 'edit' template" do
        diem_chuyen_can = DiemChuyenCan.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        DiemChuyenCan.any_instance.stub(:save).and_return(false)
        put :update, {:id => diem_chuyen_can.to_param, :diem_chuyen_can => { "ma_sinh_vien" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested diem_chuyen_can" do
      diem_chuyen_can = DiemChuyenCan.create! valid_attributes
      expect {
        delete :destroy, {:id => diem_chuyen_can.to_param}, valid_session
      }.to change(DiemChuyenCan, :count).by(-1)
    end

    it "redirects to the diem_chuyen_cans list" do
      diem_chuyen_can = DiemChuyenCan.create! valid_attributes
      delete :destroy, {:id => diem_chuyen_can.to_param}, valid_session
      response.should redirect_to(diem_chuyen_cans_url)
    end
  end

end