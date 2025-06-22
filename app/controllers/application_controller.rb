class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # CSRF保護を有効化（API + Cookie認証の場合）
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  private

  # Cookie認証のヘルパーメソッド
  def set_auth_cookie(user)
    cookies.permanent.signed[:session_token] = {
      value: user.token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax
    }
  end

  def clear_auth_cookie
    cookies.delete(:session_token)
  end

  # トークンまたはCookieによる認証
  def current_user
    @current_user ||= find_user_from_token || find_user_from_cookie
  end

  def find_user_from_token
    authenticate_with_http_token do |token, _|
      User.find_by(token: token)
    end
  end

  def find_user_from_cookie
    token = cookies.permanent.signed[:session_token]
    User.find_by(token: token) if token
  end

  def authenticate_user!
    unless current_user
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
