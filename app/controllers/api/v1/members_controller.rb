module Api
  module V1
    class MembersController < ApiController
      def index
        @members = Member.includes(:account).all
        render "api/v1/members/index.json"
      end

      def create
        member = Member.new(member_params)
        service = ::MemberSetupService.new(member: member, credit: 100.00).commit

        if service.errors.empty?
          head :no_content
        else
          json = { errors: service.errors }.to_json
          render json: json, status: :bad_request
        end
      end

      def update
        member = Member.find(params[:id])
        if member.update(member_params)
          head :no_content
        else
          json = { errors: member.errors.full_messages }.to_json
          render json: json, status: :bad_request
        end
      end

      private

      def member_params
        params.require(:member).permit(:name, :email)
      end
    end
  end
end
