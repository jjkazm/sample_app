module SessionsHelper

  #Logs in a given user
  def log_in(user)
    session[:user_id] = user.id
  end


  # Returns logged in user (if any)
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # Returns true if user is logged in, otherwise false
  def logged_in?
    !!current_user
  end
end
