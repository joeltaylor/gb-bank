require 'rails_helper'

RSpec.describe Account, type: :model do
  subject(:account) { Account.new }

  it "has a default balance of 0.0" do
    expect(account.balance).to eq(0.0)
  end

  it "belongs to a member" do
    expect(account).to respond_to(:member)
  end

  it "has many transactions" do
    expect(account).to respond_to(:transactions)
  end
end
