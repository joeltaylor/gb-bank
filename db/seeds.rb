require 'faker'

puts "Removing previous seed data"
Transaction.destroy_all
Account.destroy_all
Member.destroy_all
puts "Previous seed data removed"

puts "Creating members"
FactoryGirl.create_list(:member_with_account, 10)
puts "Created members"
