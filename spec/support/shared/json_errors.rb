require "rails_helper"

shared_examples_for "forbidden_requests" do

	let(:authorization_error) do
		{
			"status" => "403",
			"source" => { "pointer" => "/headers/authorizations" },
			"title" =>  "Not Authorized",
			"detail" => "You are not authorized to access this resource."
		}
	end

	it "returns a 403 status code" do
		subject
		expect(response).to have_http_status :forbidden
	end

	it "returns proper error json" do
		subject
		expect(json['error']).to eq(authorization_error)
	end
end

shared_examples_for "unauthorized_requests" do

	let(:authentication_error) do
		{
			"status" => "401",
			"source" => { "pointer" => "/code" },
			"title" =>  "Authentication code is invalid",
			"detail" => "You must provide a valid code in order to exchange it for a token."
		}
	end

	it "returns 401 status code" do
		subject
		expect(response).to have_http_status(401)
	end

	it "returns proper error body" do
		subject
		expect(json['errors']).to include(authentication_error)
	end
end
