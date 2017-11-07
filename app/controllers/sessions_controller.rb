class SessionsController < ApplicationController
  skip_before_action :authentication, only: :login
  skip_before_action :redirect_non_andelan

  def login
    if session[:current_user_info] && cookies["jwt-token"]
      redirect_to "/"
    else
      redirect_url = "#{request.protocol}#{request.host}:#{request.port}/"
      @auth_url = Figaro.env.login_url + redirect_url
    end
  end

  def logout
    reset_session
    cookies.delete :size
    redirect_url = "#{request.protocol}#{request.host}:#{request.port}/login"
    logout_url = Figaro.env.logout_url + redirect_url
    redirect_to logout_url
  end
end
