class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :csrf_tag

  def current_user
    User.find_by_session_token(session[:session_token])
  end

  def logged_in?
    return false unless current_user
    current_user.session_token == session[:session_token]
  end

  def login_user!(user)
    session[:session_token] = user.reset_session_token!
  end

  def logout
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def csrf_tag
    html = "<input type='hidden' name='authenticity_token' "
    html += "value='#{form_authenticity_token}'>"
    html.html_safe
  end
end
