class Transaction < ApplicationRecord
  validates :date, :amount, :description, presence: true
  validate  :date_cannot_be_before_account_creation,
            :date_cannot_be_in_future
  validates :description, length:  { maximum: 140 }
  validates :amount, numericality: { greater_than_or_equal_to: -999_999.99,
                                     less_than_or_equal_to: 999_999.99 }

  belongs_to :account

  private

  def date_cannot_be_before_account_creation
    return false unless date && account
    if date.end_of_day < account.created_at.beginning_of_day
      errors.add(:date, "can't be before account was created")
    end
  end

  def date_cannot_be_in_future
    return false unless date
    if date >= 1.day.from_now.beginning_of_day
      errors.add(:date, "can't be in the future")
    end
  end
end
