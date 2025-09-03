class UsersController < ApplicationController
  before_action :require_login, except: [ :new, :create, :show, :admin_panel, :index ]
  before_action :set_user, only: [ :show, :edit, :update, :destroy, :profile, :update_profile, :admin_panel ]
  skip_before_action :verify_authenticity_token, only: [ :profile, :admin_panel ]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created successfully!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "User updated successfully!"
    else
      render :edit
    end
  end

  def profile
    @account = Account.find_by(user: @user)
  end

  def update_profile
    first_name = params[:user][:first_name]
    last_name = params[:user][:last_name]

    sql = "UPDATE users SET first_name='#{first_name}', last_name='#{last_name}' WHERE id=#{@user.id}"

    ActiveRecord::Base.connection.execute(sql)

    redirect_to profile_user_path(@user), notice: "Profile updated!"
  rescue => e
    flash[:alert] = "Error updating profile: #{e.message}"
    redirect_to profile_user_path(@user)
  end

  def admin_panel
    @all_users = User.all
    @all_accounts = Account.all
    @all_transactions = Transaction.all
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User deleted successfully!"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :role, :admin, :balance)
  end
end
