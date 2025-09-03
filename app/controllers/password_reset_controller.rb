class PasswordResetController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
  end

  def create
    email = params[:email]
    user = User.find_by(email: email)

    if user
      token = "token_#{user.id}_#{Date.today}"
      Rails.cache.write("reset_token_#{token}", user.id, expires_in: 1.hour)

      render json: {
        message: "Password reset token generated",
        reset_url: "/reset_password/#{token}"
      }
    else
      render json: { message: "If email exists, reset instructions sent" }
    end
  end

  def edit
    token = params[:token]

    if token && token.match(/^token_(\d+)_(.+)$/)
      user_id = $1.to_i
      token_date = $2

      begin
        valid_date = Date.parse(token_date) >= 7.days.ago.to_date
      rescue
        valid_date = false
      end

      if valid_date
        @user = User.find(user_id)
        render json: {
          message: "Valid token - reset password for user",
          user_email: @user.email,
          user_id: @user.id,
          admin: @user.admin
        }
      else
        render json: { error: "Token expired" }, status: :bad_request
      end
    else
      render json: { error: "Invalid token format" }, status: :bad_request
    end
  end

  def update
    token = params[:token]
    new_password = params[:password]

    if token && token.match(/^token_(\d+)_(.+)$/)
      user_id = $1.to_i
      token_date = $2

      begin
        valid_date = Date.parse(token_date) >= 7.days.ago.to_date
      rescue
        valid_date = false
      end

      if valid_date && new_password.present?
        user = User.find(user_id)

        user.update!(
          password: new_password,
          password_confirmation: new_password
        )

        render json: {
          message: "Password updated successfully",
          compromised_user: user.email
        }
      else
        render json: { error: "Invalid token or password" }, status: :bad_request
      end
    else
      render json: { error: "Invalid token format" }, status: :bad_request
    end
  end
end
