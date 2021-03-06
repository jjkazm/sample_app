class UsersController < ApplicationController
  before_action :set_user, except:[:new, :create, :index]
  before_action :logged_in_user, only:[:edit, :update, :index, :destroy, :following, :followers]
  before_action :correct_user, only:[:edit, :update]
  before_action :is_admin, only: [:destroy]

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_path and return unless @user.activated
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_link
      flash[:info] = "Please check your email to activate account"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.save
      flash[:success] = "User has been updated"
      redirect_to user_path
    else
      render 'users/edit'
    end
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def destroy
    @user.destroy
    flash[:success] = "User has been destroyed"
    redirect_to users_path
  end

  def following
    @title = "Following"
    @users = @user.followees.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def set_user
      @user = User.find(params[:id])
    end



    # Checks if user is the same as user on which some action has to be performed
    def correct_user
      unless helpers.current_user?(@user)
        flash[:danger] = "You don't have permission to do that"
        redirect_to root_path
      end
    end

    def is_admin
      redirect_to root_path unless current_user.admin?

    end
end
