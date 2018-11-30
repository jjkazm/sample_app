class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :set_micropost, only: [:destroy]
  before_action :correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Post has been published"
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Post has been deleted"
    redirect_back(fallback_location: root_url)
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def set_micropost
      @micropost = Micropost.find_by(id: params[:id])
    end

    def correct_user
      redirect_to root_path unless
      @micropost.user.id == current_user.id
      end


end
