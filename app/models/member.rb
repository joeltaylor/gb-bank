class Member < ApplicationRecord
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  # Basic validation since I would rely on a confirmation e-mail as real validation
  validates_format_of :email, :with => /@/

  has_one :account
end
