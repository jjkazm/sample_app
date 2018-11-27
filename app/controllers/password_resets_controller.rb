class PasswordResetsController < ApplicationController
  before_action :get_user,           only: [:edit, :update]
  before_action :valid_user,         only: [:edit, :update]
  before_action :check_expiration,   only: [:edit, :update]
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_token
      @user.send_reset_token
      flash[:info] = "Check your email for instructions."
      redirect_to root_path
    else
      flash.now[:danger]="User not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end


# Confirms valid user
  def valid_user
    unless (@user && @user.activated? &&
            @user.authenticated?(:reset, params[:id]))
      redirect_to root_path
    end
  end

  #checks if reset link is not expired
  def check_expiration
    if @user.password_reset_expired
      flash[:danger] = "Password has expired"
      redirect_to new_password_reset_path
    end
  end
end
