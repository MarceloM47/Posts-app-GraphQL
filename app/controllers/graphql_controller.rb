# frozen_string_literal: true

class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session
  before_action :authenticate_account!, only: [:execute]
  skip_before_action :authenticate_account!, if: :mutation_is_public?

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      current_account: current_account,
    }
    result = GraphpQlCrudSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  def mutation_is_public?
    query = params[:query].to_s
    public_operations = ['login', 'register']
    public_operations.any? { |op| query.include?(op) } || 
      query.include?('__schema') || 
      query.include?('__type')
  end

  def authenticate_account!
    begin
      auth_header = request.headers['Authorization'].to_s
      Rails.logger.debug "====== Auth header completo: #{auth_header}"
      
      token = auth_header.split(' ').last
      Rails.logger.debug "====== Token extraído: #{token}"
      
      if token.blank?
        Rails.logger.debug "====== Token está en blanco"
        render json: { errors: [{ message: 'Authorization token is missing' }] }, status: :unauthorized and return
      end
  
      decoded = JsonWebToken.decode(token)
      Rails.logger.debug "====== Token decodificado: #{decoded.inspect}"
      
      if decoded.nil? || decoded[:account_id].blank?
        Rails.logger.debug "====== Token decodificado es nil o no tiene account_id"
        render json: { errors: [{ message: 'Invalid or expired token' }] }, status: :unauthorized and return
      end
  
      @current_account = Account.find_by(id: decoded[:account_id])
      Rails.logger.debug "====== Cuenta encontrada: #{@current_account.inspect}"
      
      if @current_account.nil?
        Rails.logger.debug "====== No se encontró la cuenta"
        render json: { errors: [{ message: 'User not found' }] }, status: :unauthorized and return
      end
  
    rescue JWT::DecodeError => e
      Rails.logger.debug "====== Error JWT: #{e.message}"
      render json: { errors: [{ message: 'Invalid token format' }] }, status: :unauthorized
    rescue => e
      Rails.logger.debug "====== Error general: #{e.class} - #{e.message}"
      render json: { errors: [{ message: 'Authentication error' }] }, status: :unauthorized
    end  
  end

  def current_account
    return unless request.headers['Authorization'].present?

    token = request.headers['Authorization'].split(' ').last
    decoded = JsonWebToken.decode(token)
    return unless decoded

    Account.find_by(id: decoded[:account_id])
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end
