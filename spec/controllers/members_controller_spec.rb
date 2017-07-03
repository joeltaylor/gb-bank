require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  describe "#index" do
    it "assigns @members" do
      member = FactoryGirl.create(:member)

      get :index

      expect(response).to be_success
      expect(assigns(:members)).to eq([member])
    end
  end

  describe "#new" do
    it "responds successfully" do
      get :new

      expect(response).to be_success
      expect(assigns(:member)).to be_a_new(Member)
    end
  end

  describe "#update" do
    before { @member = FactoryGirl.create(:member) }

    it "updates the member" do
      member_params = FactoryGirl.attributes_for(:member, name: "New Name")

      patch :update, params: { id: @member.id, member: member_params }

      expect(@member.reload.name).to eq("New Name")
      expect(response).to redirect_to members_path
    end
  end

  describe "#create" do
    it "creates a new member" do
      member_params = FactoryGirl.attributes_for(:member)

      expect {
        post :create, params: { member: member_params }
      }.to change(Member, :count).by(1)
      expect(response).to redirect_to members_path
    end
  end
end
