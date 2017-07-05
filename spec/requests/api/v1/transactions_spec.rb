require 'rails_helper'

RSpec.describe "Api::V1::Transaction", type: :request do
  describe "POST /api/v1/transactions" do
    let(:member)             { FactoryGirl.create(:member_with_account) }
    let(:transaction_params) { FactoryGirl.attributes_for(:transaction) }
    let(:member_params)      { { email: member.email } }

    describe "as an unauthorized user" do
      it "responds with an unauthorized status" do
        post api_v1_transactions_path, params: { transaction: transaction_params, member: member_params }

        expect(Transaction.count).to eq(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "as an authorized user" do
      context "with valid data" do
        it "creates a new transaction" do
          expect {
            post api_v1_transactions_path, params: { transaction: transaction_params,
                                                     member: member_params },
                                                     headers: auth_header
          }.to change(Transaction, :count).by(1)

          expect(response).to have_http_status(:no_content)
        end
      end

      context "with invalid data" do
        it "returns an error" do
          post api_v1_transactions_path, params: { transaction: transaction_params.merge({amount: nil}),
                                                   member: member_params },
                                                   headers: auth_header
          expect(Transaction.count).to eq(0)
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)["errors"][0]).to match("Amount")
        end
      end
    end
  end
end
