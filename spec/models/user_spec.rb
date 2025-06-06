require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  describe 'emailのバリデーション' do
    it '空だと無効であること' do
      user.email = ''
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it '形式が不正だと無効であること' do
      user.email = 'invalid_email'
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is invalid')
    end

    it '形式が正しいと有効であること' do
      user.email = 'test@example.com'
      expect(user).to be_valid
    end
  end
end
