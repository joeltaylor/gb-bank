class MembersController < ApplicationController

  def index
    @members = Member.includes(:account).all
  end

  def new
    @member = Member.new
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    member = Member.find(params[:id])
    if member.update(member_params)
      redirect_to members_path, notice: t('member.edit.success')
    else
      flash[:error] = t('error.generic_failure')
      flash[:error_messages] = member.errors.full_messages
      redirect_to members_path
    end
  end

  def create
    member = Member.new(member_params)
    service = ::MemberSetupService.new(member: member, credit: 100.00).commit

    if service.errors.empty?
      redirect_to members_path, notice: t('member.create.success')
    else
      flash[:error] = t('error.generic_failure')
      flash[:error_messages] = service.errors
      redirect_to members_path
    end
  end

  private

  def member_params
    params.require(:member).permit(:name, :email)
  end
end
