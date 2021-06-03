require "rails_helper"

shared_context "json errors" do
	shared_examples_for "unauthorized_oauth_requests" do

		let(:authentication_error) do
			{
				"status" => "401",
				"source" => { "pointer" => "/code" },
				"title" =>  "Authentication code is invalid",
				"detail" => "You must provide a valid code in order to exchange it for a token."
			}
		end

		it "returns a 401 status code" do
			subject
			expect(response).to have_http_status(401)
		end

		it "returns a proper error body" do
			subject
			expect(json["errors"]).to include(authentication_error)
		end
	end

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
			expect(json["error"]).to eq(authorization_error)
		end
	end

	shared_examples_for "not_found_requests" do
		let(:not_found_error) do
			{
				"status" => 404,
				"source" => { "pointer" => "/request/url/:id" },
				"title" => "Record not Found",
				"detail" => "We could not find the object you were looking for."
			}
		end

		it "should return 404 status code" do
			subject
			expect(response).to have_http_status(:not_found)
		end

		it "should return proper error json" do
			subject
			expect(json["errors"]).to include(not_found_error)
		end
	end
end
