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
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to members_path, notice: t('member.edit.success')
    else
      redirect_to members_path, notice: t('member.edit.failure')
    end
  end

  def create
    member = Member.new(member_params)
    if ::MemberSetupService.new(member: member, credit: 100.00).commit
      redirect_to members_path, notice: t('member.create.success')
    else
      redirect_to members_path, notice: t('member.create.failure')
    end
  end

  private

  def member_params
    params.require(:member).permit(:name, :email)
  end
end
