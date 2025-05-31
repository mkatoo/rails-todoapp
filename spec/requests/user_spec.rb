require "rails_helper"

RSpec.describe "User API", type: :request do
  describe "GET /users" do
    context "ユーザが存在しない場合" do
      it "空のリストを返す" do
        get users_path
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json).to be_empty
      end
    end

    context "ユーザが存在する場合" do
      let(:name) { "Test User" }
      let(:email) { "test@example.com" }
      let!(:user) { create(:user, name:, email:) }

      it "ユーザのリストを返す" do
        get users_path
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json.size).to eq(1)
      end

      it "ユーザの属性が正しい" do
        get users_path
        json = JSON.parse(response.body)
        expect(json.first["name"]).to eq name
        expect(json.first["email"]).to eq email
      end
    end
  end

  describe "GET /users/:id" do
    context "存在するユーザを取得した場合" do
      let(:name) { "Test User" }
      let(:email) { "test@example.com" }
      let!(:user) { create(:user, name:, email:) }

      it "ユーザを返す" do
        get user_path(user)
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json["name"]).to eq name
        expect(json["email"]).to eq email
      end
    end

    context "存在しないユーザを取得した場合" do
      it "404エラーを返す" do
        get user_path(id: -1) # 存在しないID
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /users" do
    context "有効なパラメータを送信した場合" do
      let(:name) { "New User" }
      let(:email) { "new@example.com" }
      let(:password) { "password" }
      let(:params) { { name:, email:, password: } }
      let(:time) { Time.local(1996, 5, 28, 0, 0, 0) }

      it "新しいユーザを作成する" do
        travel_to(time) do
          post users_path, params: params
        end
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["name"]).to eq name
        expect(json["email"]).to eq email
        expect(Time.parse(json["created_at"])).to eq time
      end
    end

    context "無効なパラメータを送信した場合" do
      let(:params) { { name: "", email: "invalid", password: "short" } }

      it "エラーを返す" do
        post users_path, params: params
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["email"]).to include("is invalid")
      end
    end
  end
end
