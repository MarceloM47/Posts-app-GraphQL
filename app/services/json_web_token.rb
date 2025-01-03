require 'jwt'

class JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE']

  def self.encode(payload, exp = 24.hours.from_now)
    Rails.logger.debug "Secret key present: #{SECRET_KEY.present?}"
    payload = payload.dup
    payload[:exp] = exp.to_i
    
    Rails.logger.info "Encoding payload: #{payload}"
    Rails.logger.debug "Using secret key: #{SECRET_KEY[0..5]}..." # Solo mostramos los primeros caracteres por seguridad

    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    Rails.logger.debug "Attempting to decode token with secret key present: #{SECRET_KEY.present?}"
    begin
      decoded = JWT.decode(token, SECRET_KEY)[0]
      Rails.logger.info "Decoded token: #{decoded}"
      HashWithIndifferentAccess.new decoded
    rescue JWT::DecodeError => e
      Rails.logger.error "JWT decode error: #{e.message}"
      Rails.logger.error "Token being decoded: #{token}"
      nil
    rescue => e
      Rails.logger.error "General decode error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      nil
    end
  end
end
