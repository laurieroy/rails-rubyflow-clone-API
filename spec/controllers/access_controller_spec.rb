require "rails_helper"

RSpec.describe AccessTokensController, type: :controller do
	describe "#create" do

		context "when invalid code is provided" do
			let(:github_error) {
				double("Sawyer::Resource", error: "bad_verification_code")
			}

			before do
				allow_any_instance_of(Octokit::Client).to receive(
					:exchange_code_for_token
				).and_return(github_error)
			end

			subject { post :create, params: { code: 'invalid_code' } }
			it_behaves_like "unauthorized_requests"
		end

		context "when no code is provided" do
			subject { post :create }
			it_behaves_like "unauthorized_requests"
		end

		context "when success request" do
			let(:user_data) do
				{
					login: 'jdoe1',
					url: 'http://example.com',
					avatar_url: 'http://example.com/avatar',
					name: 'Jane Doe',
					provider: 'github'
				}
			end

			before do
				allow_any_instance_of(Octokit::Client).to receive(
					:exchange_code_for_token).and_return('validaccesstoken')

				allow_any_instance_of(Octokit::Client).to receive(
					:user).and_return(user_data)
			end

			subject { post :create, params: { code: 'valid_code' } }

			it "returns 201 status_code" do
				subject
				expect(response).to have_http_status :created
			end

			it "returns proper json body" do
				expect{ subject }.to change{ User.count }.by(1)
				user = User.find_by(login: 'jdoe1')
			
				expect(json_data['attributes']).to eq(			
					{'token' => user.access_token.token })
			end
		end
	end

	describe "DELETE #destroy" do
		subject { delete :destroy }

		context "when no authorization header provided" do
		
			it_behaves_like "forbidden_requests"
		end

		context "when invalid authorizaton header is provided" do
			before { request.headers['authorization'] = "Invalid token" }
			subject { delete :destroy }

			it_behaves_like "forbidden_requests"
		end

		context "when valid request" do
			let(:user) {create :user}
			let(:access_token) { user.create_access_token }

			before { request.headers['authorization'] = "Bearer #{access_token.token}" }

			it "returns 204 status code" do
				subject
				expect(response).to have_http_status :no_content
			end

			it "removes the proper access token" do 
				expect{ subject }.to change{ AccessToken.count }.by(-1)
			end
		end
	end
	
end