require 'rails_helper'

RSpec.describe Account, type: :model do
  subject(:account) { Account.new }

  it "has a default balance of 0.00" do
    expect(account.balance).to eq(0.00)
  end

  it "is invalid with an amount greater than 999_999.99" do
    account.balance = 1_000_000.00
    expect(account).to_not be_valid
    expect { account.save(validate: false) }.to raise_error(ActiveRecord::RangeError)
  end

  it "is invalid with an balance less than -150.00" do
    account.balance = -150.01
    expect(account).to_not be_valid
  end

  it "stores balance with a precision of 2" do
    account.balance = 10.9555
    expect(account.balance).to eq(10.96)
  end

  it "belongs to a member" do
    expect(account).to respond_to(:member)
  end

  it "has many transactions" do
    expect(account).to respond_to(:transactions)
  end
end
