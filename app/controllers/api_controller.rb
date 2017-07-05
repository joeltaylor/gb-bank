class ApiController < ActionController::API 
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound do |exception|
    json  = { errors: [exception.to_s] }.to_json
    render json: json, status: :not_found
  end
  rescue_from ActionController::ParameterMissing, with: :bad_request

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
end
