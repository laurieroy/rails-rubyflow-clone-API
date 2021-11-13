require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validations' do
    it 'should have a valid factory' do
      user = build :user
      expect(user).to be_valid
    end
    
    it 'cannot be created without a login' do
      user = build :user, login: nil

      expect(user).not_to be_valid
    end

    xit 'returns an error when login is missing' do
      user = build :user, login: nil
      
      expect(user.errors.messages[:login]).to include("can't be blank")
    end

    it 'cannot be created without a provider' do
      user = build :user,  provider: nil

      expect(user).not_to be_valid
    end

    xit 'returns an error when provider is missing' do
      user = build :user,  provider: nil

      expect(user.errors.messages[:provider]).to include("can't be blank")
    end
    
    it 'validates uniqueness of login' do
      user = create :user
      other_user = build :user, login: user.login

      expect(other_user).not_to be_valid

      other_user.login = 'newlogin'

      expect(other_user).to be_valid
    end
  end
  
end
