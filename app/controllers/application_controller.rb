class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception
  before_action :append_view_paths

  rescue_from ActiveRecord::RecordNotFound, with: :record_error

  private

  def append_view_paths
    append_view_path "app/views/application"
  end

  def record_error
    flash[:error] = t('error.generic_failure')
    redirect_to members_path
  end
end
