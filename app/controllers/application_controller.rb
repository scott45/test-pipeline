require "jwt"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authentication
  before_action :redirect_non_andelan
  after_action :clear_xhr_flash

  private

  def authentication
    if cookies["jwt-token"]
      begin
        decoded_token = JWT.decode(cookies["jwt-token"], nil, false)[0]
        authorize decoded_token
      rescue JWT::ExpiredSignature
        reset_session
        redirect_url = "#{request.protocol}
                        #{request.host}:
                        #{request.port}/login"
        logout_url = Figaro.env.logout_url + redirect_url
        redirect_to logout_url
      end
    else
      redirect_to "/login", notice: "unauthenticated"
    end
  end

  def authorize(decoded_token)
    user_email = decoded_token["UserInfo"]["email"]

    if (andelan? user_email) ||
       (authorized_learner? user_email)
      create_session decoded_token
    else
      redirect_to "/login", notice: "unauthorized"
    end
  end

  def andelan?(email)
    email["andela.com"] ? true : false
  end

  def create_session(decoded_token)
    user_info = {
      name: decoded_token["UserInfo"]["name"],
      admin: decoded_token["UserInfo"]["roles"].key?("VOF_Admin"),
      picture: decoded_token["UserInfo"]["picture"],
      andelan: andelan?(decoded_token["UserInfo"]["email"]),
      email: decoded_token["UserInfo"]["email"],
      learner: authorized_learner?(decoded_token["UserInfo"]["email"])
    }
    session[:current_user_info] = user_info
  end

  def authorized_learner?(learner_email)
    learner = Bootcamper.find_by(email: learner_email)
    learner ? true : false
  end

  def redirect_non_andelan
    if cookies["jwt-token"] && !session[:current_user_info][:andelan]
      redirect_to learner_path
    end
  end

  def redirect_unauthorized_learner
    if cookies["jwt-token"] && !session[:current_user_info][:learner]
      redirect_to index_path
    end
  end

  def record_not_found
    render plain: "404 Not Found", status: 404
  end

  def clear_xhr_flash
    if request.xhr?
      flash.discard
    end
  end
end
