require 'rails_helper'

RSpec.describe Member, type: :model do
  subject(:member) { Member.new(name: 'John Doe', email: 'john@example.com') }

  describe "validations" do
    it "is valid with a name and email" do
      expect(member).to be_valid
    end

    it "is invalid without a name" do
      member.name = nil
      expect(member).to_not be_valid
      expect { member.save(validate: false) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "is invalid without a email" do
      member.email = nil
      expect(member).to_not be_valid
      expect { member.save(validate: false) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "is invalid without a unique email" do
      Member.create(name: 'John Doesest', email: 'john@example.com')
      expect(member).to_not be_valid
      expect { member.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "validates the proper format of an email address" do
      member.email = "person.com"
      expect(member).to_not be_valid
    end
  end

  describe "before_save" do
    it "downcases an email before creating a new member" do
      member.email = "SOMEONE@eMaIl.CoM"
      member.save
      expect(member.email).to eq("someone@email.com")
    end

    it "downcases email when updated" do
      member.save
      member.update(email: "NEW@email.com")
      expect(member.email).to eq("new@email.com")
    end
  end

  describe "associations" do
    it "has one account" do
      expect(member).to have_one(:account)
    end
  end
end
