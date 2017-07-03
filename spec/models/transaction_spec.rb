require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject(:transaction) { Transaction.new(date: Date.today, amount: 100.00, description: "Gas Station")}

  describe "validations" do
    it "is valid with a date, amount, and description" do
      expect(transaction).to be_valid
    end

    it "is invalid without a date" do
      transaction.date = nil
      expect(transaction).to_not be_valid
      expect { transaction.save(validate: false) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "is invalid without an amount" do
      transaction.amount = nil
      expect(transaction).to_not be_valid
      expect { transaction.save(validate: false) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "is invalid with an amount greater than 999_999.99" do
      transaction.amount = 1_000_000.00
      expect(transaction).to_not be_valid
      expect { transaction.save(validate: false) }.to raise_error(ActiveRecord::RangeError)
    end

    it "is invalid with an amount less than -999_999.99" do
      transaction.amount = -1_000_000.00
      expect(transaction).to_not be_valid
      expect { transaction.save(validate: false) }.to raise_error(ActiveRecord::RangeError)
    end

    it "is invalid without a description" do
      transaction.description = nil
      expect(transaction).to_not be_valid
      expect { transaction.save(validate: false) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "is invalid with a description that exceeds 140 characters" do
      transaction.description = "abc"*140
      expect(transaction).to_not be_valid
    end

    it "stores amounts with a precision of 2" do
      transaction.amount = 10.9555
      expect(transaction.amount).to eq(10.96)
    end
  end

  describe "associations" do
    it "belongs to an account" do
      expect(transaction).to respond_to(:account)
    end
  end
end
