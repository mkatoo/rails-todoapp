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
    end

    context "誤った認証情報を送信した場合" do
      let(:params) { { email:, password: "wrong_password" } }

      it "エラーメッセージを返す" do
        post auth_path, params: params
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq "Invalid email or password"
      end
    end
  end
end
