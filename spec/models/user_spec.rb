require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'nameのバリデーション' do
    it '3文字未満だと無効であること' do
      user.name = 'ab'
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include('is too short (minimum is 3 characters)')
    end

    it '10文字を超えると無効であること' do
      user.name = 'a' * 11
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include('is too long (maximum is 10 characters)')
    end

    it '3文字以上10文字以下であれば有効であること' do
      user.name = 'validname'
      expect(user).to be_valid
    end
  end

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
