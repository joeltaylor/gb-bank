require "rails_helper"

RSpec.describe MemberSetupService do
  let(:member) { FactoryGirl.build(:member) }
  subject(:create_member) { MemberSetupService.new(member: member).commit }

  it "creates an account for the user" do
    create_member
    expect(member.account).to be_present
  end

  it "creates a promotional transaction" do
    create_member

    transaction = member.account.transactions.last

    expect(transaction.amount).to eq(100.00)
    expect(transaction.description).to match("Promotion")
    expect(transaction.date).not_to be_nil
  end

  it "applies the promotional transaction to the member's account" do
    create_member
    expect(member.account.balance).to eq(100.00)
  end

  it "rollsback in the event of an error" do
    invalid_amount = 10**10

    MemberSetupService.new(member: member, credit: invalid_amount).commit

    expect(Member.count).to eq(0)
    expect(Account.count).to eq(0)
    expect(Transaction.count).to eq(0)
  end
end
