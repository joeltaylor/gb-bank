class Member < ApplicationRecord
  validates :name, :email, presence: true
  validates :email, uniqueness: true

  has_one :account
end
