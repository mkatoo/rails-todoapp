require 'rails_helper'

RSpec.describe "Auth", type: :request do
  describe "POST /auth" do
    let(:email) { "user@example.com" }
    let(:password) { "password" }
    let(:token) { "TOKEN" }
    let!(:user) { create(:user, email:, password:, token:) }

    context "正しい認証情報を送信した場合" do
      let(:params) { { email:, password: } }

      it "トークンを返す" do
        post auth_path, params: params
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["token"]).to eq token
      end

      it "セキュアなCookieを設定する" do
        post auth_path, params: params
        expect(response).to have_http_status(:ok)
        expect(response.headers["Set-Cookie"]).to be_present
      end
    end

    context "誤った認証情報を送信した場合" do
      let(:params) { { email:, password: "wrong_password" } }

      it "エラーメッセージを返す" do
        post auth_path, params: params
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq "Invalid email or password"
      end

      it "Cookieを設定しない" do
        post auth_path, params: params
        expect(response).to have_http_status(:unauthorized)
        expect(response.headers["Set-Cookie"]).to be_blank
      end
    end
  end

  describe "DELETE /auth" do
    let!(:user) { create(:user) }

    it "ログアウトメッセージを返す" do
      delete auth_path
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq "Logged out successfully"
    end

    it "Cookieを削除する" do
      # まずログインしてCookieを設定
      post auth_path, params: { email: user.email, password: user.password }
      expect(response.headers["Set-Cookie"]).to include("session_token=")

      # ログアウトしてCookieが削除されることを確認
      delete auth_path
      expect(response).to have_http_status(:ok)
      expect(response.headers["Set-Cookie"]).to include("max-age=0")
    end
  end
end
