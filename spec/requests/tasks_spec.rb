require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:email) { "user@example.com" }
  let(:password) { "password" }
  let(:token) { "TOKEN" }
  let!(:user) { create(:user, email:, password:, token:) }

  describe "GET /index" do
    context "ユーザが認証されていない場合" do
      it "401エラーを返す" do
        get tasks_path
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "ユーザが認証されている場合" do
      context "タスクが存在しない場合" do
        it "空のリストを返す" do
          get tasks_path, headers: { 'Authorization' => "Bearer #{token}" }
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq([])
        end
      end

      context "タスクが存在する場合" do
        let!(:tasks) { create_list(:task, 3, user:) }

        it "タスクのリストを返す" do
          get tasks_path, headers: { 'Authorization' => "Bearer #{token}" }
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq(tasks.as_json)
        end
      end
    end
  end
end
