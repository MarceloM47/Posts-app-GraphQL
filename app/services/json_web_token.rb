require 'jwt'

class JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE']

  def self.encode(payload, exp = 24.hours.from_now)
    payload = payload.dup
    payload[:exp] = exp.to_i
    
    Rails.logger.info "Encoding payload: #{payload}"

    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    begin
      decoded = JWT.decode(token, SECRET_KEY)[0]
      Rails.logger.info "Decoded token: #{decoded}"
      HashWithIndifferentAccess.new decoded
    rescue JWT::DecodeError => e
      Rails.logger.error "JWT decode error: #{e.message}"
      nil
    rescue => e
      Rails.logger.error "General decode error: #{e.message}"
      nil
    end
  end
end
