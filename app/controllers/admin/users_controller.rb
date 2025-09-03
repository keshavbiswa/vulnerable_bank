class Admin::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :require_login

  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { message: "User created successfully", user: @user }
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_content
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      render json: { message: "User updated successfully", user: @user }
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    render json: { message: "User deleted successfully" }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                  :first_name, :last_name, :role, :admin)
  end
end
