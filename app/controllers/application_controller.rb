class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception
  before_action :append_view_paths

  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:error] = t('error.generic_failure')
    flash[:error_messages] = [exception.to_s]
    redirect_to members_path
  end

  private

  def append_view_paths
    append_view_path "app/views/application"
  end
end
