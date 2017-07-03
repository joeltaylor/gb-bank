require 'faker'

puts "Removing previous seed data"
Member.destroy_all
puts "Previos seed data removed"

puts "Creating members"
FactoryGirl.create_list(:member, 10)
puts "Created members"
