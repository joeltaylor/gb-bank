class MemberSetupService
  attr_reader :member, :credit, :errors

  def initialize(member:, credit: nil)
    @member = member
    @credit = credit || active_promotion.credit
    @errors = []
  end

  def commit
    Account.transaction do
      begin
        member.save!
        initialize_account
        create_account_promotion
      rescue StandardError => e
        Rails.logger.info("MemberSetupService Error: #{e}")
        @errors << e.to_s
        raise ActiveRecord::Rollback
      end
    end
    self
  end

  private

  def initialize_account
    @account = Account.create!(member: member, balance: credit)
  end

  def create_account_promotion
    return unless active_promotion
    Transaction.create!( amount: credit,
                        account: @account,
                        description: "Promotional sign-on bonus",
                        date: Time.current
                       )
  end

  # Treating this as if it weree a query method in the event we have multiple
  # promotions. For the sake of simplicity, I'm stubbing it out.
  def active_promotion
    @active_promotion ||= OpenStruct.new(credit: 100.00)
  end
end
