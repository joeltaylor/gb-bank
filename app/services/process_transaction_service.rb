class ProcessTransactionService
  AccountMissingError = Class.new(StandardError)

  attr_reader :transaction, :member, :errors

  def initialize(transaction:, member:)
    @transaction = transaction
    @member      = member
    @errors       = []
  end

  def commit
    Account.transaction do
      begin
        associate_transaction_with_account!
        transaction.save!
        account.lock!
        apply_transaction_amount_to_account_balance
        account.save!
      rescue StandardError => e
        Rails.logger.info("ProcessTransactionService Error: #{e}")
        @errors << e.to_s
        raise ActiveRecord::Rollback
      end
    end
    self
  end

  private

  def associate_transaction_with_account!
    raise AccountMissingError.new("Missing account for transaction") unless account
    transaction.account = account
  end

  def apply_transaction_amount_to_account_balance
    account.balance += transaction.amount
  end

  def account
    member.account
  end
end
