require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  describe "#new" do

    it "renders the transactions/new template" do
      get :new
      expect(response).to render_template("transactions/new")
    end

    it "responds successfully" do
      get :new

      expect(response).to be_success
      expect(assigns(:transaction)).to be_a_new(Transaction)
    end
  end

  describe "#create" do
    let(:member) {FactoryGirl.create(:member_with_account) }

    context "when valid" do
      it "creates a new transaction" do
        transaction_params = FactoryGirl.attributes_for(:transaction)
        member_params = { email: member.email }

        expect {
          post :create, params: { transaction: transaction_params, member: member_params }
        }.to change(Transaction, :count).by(1)

        expect(response).to redirect_to members_path
        expect(flash[:notice]).to be_present
      end
    end

    context "when invalid" do
      it "redirects with an error" do
        transaction_params = FactoryGirl.attributes_for(:transaction).merge({amount: nil})
        member_params = { email: member.email }

        post :create, params: { transaction: transaction_params, member: member_params }

        expect(Transaction.count).to eq(0)
        expect(flash[:error]).to be_present
        expect(flash[:error_messages]).to be_present
        expect(response).to redirect_to members_path
      end
    end
  end
end
