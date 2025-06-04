require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:email) { "user@example.com" }
  let(:password) { "password" }
  let(:token) { "TOKEN" }
  let!(:user) { create(:user, email:, password:, token:) }

  describe "GET /tasks" do
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

  describe "POST /tasks" do
    context "ユーザが認証されていない場合" do
      it "401エラーを返す" do
        post tasks_path, params: { content: "New Task" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "ユーザが認証されている場合" do
      let(:content) { "New Task" }

      it "新しいタスクを作成する" do
        post tasks_path, params: { content: }, headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["content"]).to eq(content)
        expect(json["user_id"]).to eq(user.id)
      end

      it "無効なパラメータでタスクを作成しようとすると422エラーを返す" do
        post tasks_path, params: { content: "" }, headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /tasks/:id" do
    context "ユーザが認証されていない場合" do
      let!(:task) { create(:task, user:) }

      it "401エラーを返す" do
        patch task_path(task), params: { content: "Updated Task" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "ユーザが認証されている場合" do
      let!(:task) { create(:task, user:) }

      it "タスクを更新する" do
        patch task_path(task), params: { content: "Updated Task" }, headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["content"]).to eq("Updated Task")
      end

      it "無効なパラメータでタスクを更新しようとすると422エラーを返す" do
        patch task_path(task), params: { content: "" }, headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /tasks/:id" do
    context "ユーザが認証されていない場合" do
      let!(:task) { create(:task, user:) }

      it "401エラーを返す" do
        delete task_path(task)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "ユーザが認証されている場合" do
      let!(:task) { create(:task, user:) }

      it "タスクを削除する" do
        delete task_path(task), headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:no_content)
        expect(Task.count).to eq 0
      end
    end
  end
end
