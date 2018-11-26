class PasswordResetsController < ApplicationController
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
end
