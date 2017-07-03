class MemberSetupService
    attr_reader :member, :credit

    def initialize(member:, credit: 0.00)
      @member = member
      @credit = credit
    end

    def commit
      Account.transaction do
        begin
          member.save!
          initialize_account
          create_account_promotion
        rescue StandardError => e
          raise ActiveRecord::Rollback
        end
      end
    end

    private

    def initialize_account
      @account = Account.create!(member: member, balance: credit)
    end

    def create_account_promotion
      return if credit <= 0.00
      Transaction.create!( amount: credit,
                           account: @account,
                           description: "Promotional sign-on bonus",
                           date: Time.current
                         )
    end
  end
