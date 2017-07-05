module Api
  module V1
    class TransactionsController < ApiController
      def create
        transaction = Transaction.new(transaction_params)
        service     = ::ProcessTransactionService.new(transaction: transaction,
                                                      member: member).commit
        if service.errors.empty?
          head :no_content
        else
          json = { errors: service.errors }.to_json
          render json: json, status: :bad_request
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
  end
end
