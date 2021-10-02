class ApplicationController < ActionController::API
	class AuthorizationError < StandardError; end

	rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
	rescue_from AuthorizationError, with: :authorization_error

	before_action :authorize!
	
	include JsonapiErrorsHandler
	
  ErrorMapper.map_errors!({
			'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound',
			'Authorizer::AuthorizationError' => 'JsonapiErrorsHandler::Errors::Forbidden'	
  })
	rescue_from ::StandardError, with: lambda { |e| handle_error(e) }
	rescue_from ActiveRecord::RecordInvalid, with: lambda { |e| handle_validation_error(e) }
	rescue_from ActiveModel::ValidationError, with: lambda { |e| handle_validation_error(e) }

	# include Authorizer
  # include Authenticator
  # include Pagination

	private

	def access_token
		provided_token = request.authorization&.gsub(/\ABearer\s/, '')
		@access_token = AccessToken.find_by(token: provided_token)
	end

	def authentication_error
		error = {
			"status" => "401",
			"source" => { "pointer" => "/code" },
			"title" =>  "Authentication code is invalid",
			"detail" => "You must provide a valid code to exchange it for a token."
		}
		render json: { "errors": [ error ] }, status: 401
	end

	def authorization_error
		error = {
			"status" => "403",
			"source" => { "pointer" => "/headers/authorizations" },
			"title" =>  "You're not authorized",
			"detail" => "You are not authorized to access this resource."
		}
		render json: { "errors": [ error ] }, status: 403
	end

	def authorize! 
		raise AuthorizationError unless current_user
	end

	def current_user
		@current_user = access_token&.user
	end

	def handle_validation_error(error)
		error_model = error.try(:model) || error.try(:record)
		mapped = JsonapiErrorsHandler::Errors::Invalid.new(errors: error_model.errors)
		render_error(mapped)
	end
end
