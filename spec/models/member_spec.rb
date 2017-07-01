require 'rails_helper'

RSpec.describe Member, type: :model do
  subject(:member) { Member.new(name: 'John Doe', email: 'john@example.com') }

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

  it "is invald without a unique email" do
    Member.create(name: 'John Doesest', email: 'john@example.com')
    expect(member).to_not be_valid
    expect { member.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
  end
end
