class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

private

  #Confirms user is logged in
  def logged_in_user
    unless helpers.logged_in?
      helpers.remember_url
      flash[:danger] = "Please login first"
      redirect_to login_path
    end
  end

end
