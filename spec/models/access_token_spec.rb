require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  xdescribe '#validations' do
    xit 'has a valid factory' do
      access_token = build :access_token
      expect(access_token).to be_valid
    end

    xit 'validates token' do
      access_token = build :access_token, token: nil, user_id: nil
      expect(access_token).not_to be_valid
    end
  end

  describe "#new" do
    it "should have a token present after initialization" do
      expect(AccessToken.new.token).to be_present
    end
    
  it "generates an uniq token" do
      user = create :user
      expect{ user.create_access_token }.to change{ AccessToken.count }.by(1)
      expect(user.build_access_token).to be_valid
    end

    it "generates a token only once" do
      user = create :user
      access_token = user.create_access_token

      expect(access_token.token).to eq(access_token.reload.token)
    end
  end
  
end
