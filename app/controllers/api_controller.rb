class ApiController < ApplicationController
  before_action :authenticate

  protect_from_forgery with: :exception
  rescue_from JSON::ParserError, with: :bad_request

  rescue_from ActiveRecord::RecordNotFound do |exception|
    json  = { errors: [exception.to_s] }.to_json
    render json: json, status: :not_found
  end

  private

  def authenticate
    authenticate_token || render_unathorized
  end

  def authenticate_token
    authenticate_or_request_with_http_token do |token, options|
      ActiveSupport::SecurityUtils.secure_compare(token, Rails.application.secrets.token)
    end
  end

  def render_unauthorized
    render json: 'Bad credentials', status: 401
  end

  # def append_view_paths
  #   append_view_path "app/views/application"
  # end
end
