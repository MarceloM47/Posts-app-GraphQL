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
    public_operations.any? { |op| query.include?(op) }
  end

  def authenticate_account!
    token = request.headers['Authorization'].to_s.split(' ').last
    if token.blank?
      render json: { errors: [{ message: 'Authorization token is missing' }] }, status: :unauthorized and return
    end

    decoded = JsonWebToken.decode(token)
    if decoded.nil? || decoded[:account_id].blank?
      render json: { errors: [{ message: 'Invalid or expired token' }] }, status: :unauthorized and return
    end

    @current_account = Account.find_by(id: decoded[:account_id])
    if @current_account.nil?
      render json: { errors: [{ message: 'User not found' }] }, status: :unauthorized and return
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
