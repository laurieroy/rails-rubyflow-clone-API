require "rails_helper"

describe UserAuthenticator do
	describe "#perform" do
		let(:authenticator) { described_class.new("sample_code") }
		subject { authenticator.perform }

		context "when code is incorrect" do
			let(:error) {
				double("Sawyer::Resource", error: "bad_verification_code")
			}

			before do
				allow_any_instance_of(Octokit::Client).to receive(
					:exchange_code_for_token
				).and_return(error)
			end

			it "raises an error" do
				expect{ subject }.to raise_error(
					UserAuthenticator::AuthenticationError
				)
				expect(authenticator.user).to be_nil
			end	
		end

		context "when code is correct" do
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
# Tutorial passes this test, but if run code out of order, no way to know last saved user was Jane Doe
			it "saves the user if user does not exist" do
				expect{ subject }.to change{ User.count }.by(1)
				expect(User.last.name).to eq('Jane Doe')
				# expect(authenticator.user).to be_nil
			end

			it 'reuses already registered user' do
				user = create :user, user_data

				expect{ subject }.not_to  change{ User.count}
				expect(authenticator.user).to eq(user)
			end

			it "creates and sets user's access token" do
				expect{ subject }.to change{ AccessToken.count }.by(1)
				expect(authenticator.access_token).to be_present
			end
		end
	end
end
