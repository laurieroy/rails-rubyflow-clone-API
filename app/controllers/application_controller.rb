class ApplicationController < ActionController::API
	include JsonapiErrorsHandler
	
  ErrorMapper.map_errors!({
			"ActiveRecord::RecordNotFound" => "JsonapiErrorsHandler::Errors::NotFound",
			"ActiveRecord::ActiveRecord::RecordInvalid" => "JsonapiErrorsHandler::Errors::Invalid",
			"UserAuthenticator::AuthenticationError" => "JsonapiErrorsHandler::Errors::Unauthorized",
			"ApplicationController::AuthorizationError" => "JsonapiErrorsHandler::Errors::Forbidden"
  })
  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }
end
