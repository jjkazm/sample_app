module SessionsHelper

  #Logs in a given user
  def log_in(user)
    session[:user_id] = user.id
  end

  #Creates persistent session for user
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token

  end


  # Returns logged in user (if any)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if user is logged in, otherwise false
  def logged_in?
    !!current_user
  end

  # Forgets permanent user
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  # Logs out user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    current_user = nil
  end

  # Returns true if user is current user
  def current_user?(user)
      user == current_user
  end

  # Redirects to stored location (or to default)
  def redirect_back_or (default)
    redirect_to(session[:forwarding_url] || default )
    session.delete(:forwarding_url)
  end

  # Remembers desired URL
  def remember_url
    session[:forwarding_url] = request.original_url if request.get?
  end
end
