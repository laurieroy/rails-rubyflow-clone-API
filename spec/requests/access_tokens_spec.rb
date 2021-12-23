require "rails_helper"

 RSpec.describe AccessTokensController, type: :controller do
 	describe "#create" do

 		shared_examples_for "unauthorized_requests" do

 			let(:error) do
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
 				expect(json["errors"]).to include(error)
 			end
 		end

 		context "when invalid code is provided" do
 			let(:github_error) {
 				double("Sawyer::Resource", error: "bad_verification_code")
 			}

 			before do
 				allow_any_instance_of(Octokit::Client).to receive(
 					:exchange_code_for_token
 				).and_return(github_error)
 			end

 			subject { post :create, params: { code: "invalid_code" } }
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

 end 