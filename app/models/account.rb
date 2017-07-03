class Account < ApplicationRecord
  validates :balance, numericality: { greater_than_or_equal_to: -150.00,
                                      less_than_or_equal_to: 999_999.99 }

  belongs_to :member
  has_many :transactions

end
