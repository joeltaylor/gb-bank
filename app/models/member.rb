class Member < ApplicationRecord
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  # Basic validation since I would rely on a confirmation e-mail as real validation
  validates_format_of :email, :with => /@/

  before_save :downcase_email!, if: :email_changed?

  has_one :account

  private

  def downcase_email!
    self.email.downcase!
  end
end
