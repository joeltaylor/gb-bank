class TransactionsController < ApplicationController
  def new
    @transaction = Transaction.new
  end

  def create
    transaction = Transaction.new(transaction_params)
    service     = ::ProcessTransactionService.new(transaction: transaction,
                                                   member: member).commit
    if service.errors.empty?
      redirect_to members_path, notice: t('transaction.create.success')
    else
      flash[:error] = t('error.generic_failure')
      flash[:error_messages] =  service.errors
      redirect_to members_path
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit([:amount, :description, :date])
  end

  def member
    Member.find_by!(email: params[:member][:email].downcase)
  end
end
