class ProcessTransactionService
  attr_reader :transaction, :member, :account

  def initialize(transaction:, member:)
    @transaction = transaction
    @member      = member
    @account     = member.account
  end

  def commit
    # We could call MemberSetupService to setup a missing account
    return false unless account

    Account.transaction do
      begin
        transaction.save!
        member.account.lock!
        apply_transaction_amount_to_account_balance
        account.save!
      rescue StandardError => e
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def apply_transaction_amount_to_account_balance
    account.balance += transaction.amount
  end

end
