module BootcampersHelper
  def uploaded_cycle_url
    "/?city=#{@city}&cycle=#{@cycle}&" \
      "decision_one=All&decision_two=All&user_action=f"
  end

  def display_error_message(error)
    if error[:email].count == 1
      "This email address occurs more than once:"
    else
      "The following email addresses occur more than once:"
    end
  end

  def redirect_non_admin
    unless helpers.admin?
      redirect_to index_path
    end
  end

  def save_decision(bootcamper, decision_params)
    if bootcamper.update(decision_params)
      flash[:notice] = "decision-comments-success"
    else
      flash[:error] = bootcamper.errors.full_messages[0]
    end
  end
end
