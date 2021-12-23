require "rails_helper"

RSpec.describe AccessToken, type: :model do
  describe "#validatons" do
    before do
      @access_token = create(:access_token)
    end

    it "has a valid factory" do
      expect(@access_token).to be_valid
    end

    it "is invalid without token" do
      @access_token.token = nil
      
      expect(@access_token).not_to be_valid
    end

    it "is required to have an user assocation" do
      @access_token.user_id = nil
      
      expect(@access_token).not_to be_valid
    end
  end

  describe "#new" do
    it "has a token present after initialization" do
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
