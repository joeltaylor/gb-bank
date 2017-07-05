module ApiHelpers
  def auth_header
    { "AUTHORIZATION" => "Token token=#{Rails.application.secrets.token}" }
  end
end
