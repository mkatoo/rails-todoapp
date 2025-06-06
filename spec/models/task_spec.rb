require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let(:task) { build(:task, user:) }

  describe 'contentのバリデーション' do
    it '空だと無効であること' do
      task.content = ''
      expect(task).not_to be_valid
      expect(task.errors[:content]).to include("can't be blank")
    end

    it '空でないと有効であること' do
      task.content = 'Test Task'
      expect(task).to be_valid
    end
  end
end
