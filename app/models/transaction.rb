class Transaction < ApplicationRecord
  validates :date, :amount, :description, presence: true
  validates :description, length:  { maximum: 140 }
  validates :amount, numericality: { greater_than_or_equal_to: -999_999.99,
                                     less_than_or_equal_to: 999_999.99 }

  belongs_to :account
end
