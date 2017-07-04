require "rails_helper"

RSpec.describe ProcessTransactionService do
  let(:member)      { FactoryGirl.create(:member_with_account) }
  let(:transaction) { FactoryGirl.build(:transaction, account: nil, amount: 10.00) }

  subject(:process_transaction) { ProcessTransactionService.new(transaction: transaction,
                                                                member: member).commit}

  it "associates the transaction with the member's account" do
    process_transaction
    expect(transaction.account).to eq(member.account)
  end

  it "saves the transaction" do
    expect { process_transaction }.to change(Transaction, :count).by(1)
  end

  it "applies the transaction amount to the account balance" do
    expect { process_transaction }.to change(member.account, :balance).by(10.00)
  end

  context "without an account" do
    let(:member) { FactoryGirl.create(:member) }

    it "cancels the transaction" do
      expect(Transaction.count).to eq(0)
    end

    it "adds a missing account error" do
      expect(process_transaction.errors[0]).to match("Missing account")
    end
  end
end
