require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  describe "#index" do
    it "assigns @members" do
      member = FactoryGirl.create(:member)

      get :index

      expect(response).to be_success
      expect(assigns(:members)).to eq([member])
    end

    it "renders the members/index template" do
      get :index
      expect(response).to render_template("members/index")
    end
  end

  describe "#new" do
    it "responds successfully" do
      get :new

      expect(response).to be_success
      expect(assigns(:member)).to be_a_new(Member)
    end

    it "renders the members/new template" do
      get :new
      expect(response).to render_template("members/new")
    end
  end

  describe "#update" do
    before { @member = FactoryGirl.create(:member) }

    context "when valid" do
      it "updates the member" do
        member_params = FactoryGirl.attributes_for(:member, name: "New Name")

        patch :update, params: { id: @member.id, member: member_params }

        expect(@member.reload.name).to eq("New Name")
        expect(flash[:notice]).to be_present
        expect(response).to redirect_to members_path
      end
    end

    context "when invalid" do
      it "redirects with an error" do
        member_params = FactoryGirl.attributes_for(:member, email: "lala")

        patch :update, params: { id: @member.id, member: member_params }

        expect(@member.reload.email).not_to eq("lala")
        expect(flash[:error]).to be_present
        expect(response).to redirect_to members_path
      end
    end
  end

  describe "#create" do
    context "when valid" do
      it "creates a new member" do
        member_params = FactoryGirl.attributes_for(:member)

        expect {
          post :create, params: { member: member_params }
        }.to change(Member, :count).by(1)
        expect(response).to redirect_to members_path
      end
    end

    context "when invalid" do
      it "redirects with an error" do
        member_params = FactoryGirl.attributes_for(:member, email: nil)

        post :create, params: { member: member_params }

        expect(Member.count).to eq(0)
        expect(flash[:error]).to be_present
        expect(response).to redirect_to members_path
      end
    end
  end
end
