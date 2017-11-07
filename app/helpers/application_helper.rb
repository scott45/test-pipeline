module ApplicationHelper
  def admin?
    email = session[:current_user_info][:email]

    if Rails.env == "production" && user_is_test_admin?(email)
      session[:current_user_info][:admin] = false
    end

    session[:current_user_info][:admin]
  end

  def user_is_test_admin?(email)
    email == "test-user-admin@andela.com"
  end

  def authorized_learner?
    session[:current_user_info][:learner] == true
  end

  def set_status_color(status)
    "status-" + status.to_s.split(" ").join.downcase
  end

  def user_is_lfa?(camper_id)
    email = session[:current_user_info][:email]
    Bootcamper.where(
      "camper_id = :camper_id AND
        (week_one_lfa = :email OR week_two_lfa = :email)",
      email: email, camper_id: camper_id
    ).present?
  end

  def set_metric_description(metric)
    metric_description = metric.description.split(" * ")[0]
    description_part = metric.description.split(" * ")[1]
    unless description_part.nil?
      metric_description = metric_description + "\n" + description_part
    end
    metric_description
  end
end
