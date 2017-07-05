require 'rails_helper'

RSpec.describe "Api::V1::Members", type: :request do
  describe "GET /api/v1/members" do
    before { FactoryGirl.create_list(:member_with_account, 3) }

    describe "as an unauthorized user" do
      it "responds with an unauthorized status" do
        get api_v1_members_path

        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "as an authorized user" do
      it "returns all the members" do
        get api_v1_members_path, headers: auth_header

        json = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(json.length).to eq(3)
        expect(json.map {|m| m["name"] }).to eq(Member.all.map(&:name))
        expect(json.first.keys).to eq(["email", "name", "balance"])
      end
    end
  end

  describe "POST /api/v1/members" do
    let(:member_params) { FactoryGirl.attributes_for(:member) }

    describe "as an unauthorized user" do
      it "responds with an unauthorized status" do
        post api_v1_members_path, params: { member: member_params }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "as an authorized user" do
      context "with valid data" do
        it "creates a new member" do
          expect {
            post api_v1_members_path, params: { member: member_params }, headers: auth_header
          }.to change(Member, :count).by(1)

          expect(response).to have_http_status(:no_content)
          expect(Member.last.account.balance).to eq(100.00)
        end
      end

      context "with invalid data" do
        it "fails with errors" do
          post api_v1_members_path, params: { member: member_params.merge({email: nil}) },
                                    headers: auth_header

          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe "PUT /api/v1/members/:id" do
    before { @member = FactoryGirl.create(:member) }

    describe "as an unauthorized user" do
      it "responds with an unauthorized status" do
        put api_v1_member_path(@member), params: { member: {name: "New Name"} }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "as an authorized user" do
      context "with valid data" do
        it "updates a new member" do
          put api_v1_member_path(@member), params: { member: {name: "New Name"} }, headers: auth_header

          expect(@member.reload.name).to eq("New Name")
          expect(response).to have_http_status(:no_content)
        end
      end

      context "with invalid data" do
        it "fails with errors" do
          put api_v1_member_path(@member), params: { member: {name: ""} }, headers: auth_header

          expect(@member.reload.name).not_to be_empty
          expect(response).to have_http_status(:bad_request)
        end
      end

      context "with a missing user" do
        it "responds with a not_found status" do
          put api_v1_member_path(10), params: { member: {name: ""} }, headers: auth_header

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
