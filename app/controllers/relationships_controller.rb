class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    user = User.find_by(id: params[:followed_id])
    current_user.follow(user)
    redirect_to user_path(user)

  end
  def destroy
    user = Relationship.find_by(id: params[:id]).followed
    relationship = Relationship.find_by(id: params[:id])
    relationship.destroy
    redirect_to user_path(user)
  end
end
