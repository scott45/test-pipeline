module IndexHelper
  def pagination_metadata(current_page, page_size, page_count, total_count)
    start_count = page_size.to_i * (current_page - 1)
    count_message = "#{start_count + page_count} of #{total_count} entries"
    result = total_count.zero? ? start_count : start_count + 1

    "Showing #{result} to " + count_message
  end

  def lfa_week1(city, cycle)
    lfas_emails = Bootcamper.lfas(city, cycle)
    get_lfas_info(lfas_emails)
  end

  def lfa_week2(city, cycle)
    lfas_emails = Bootcamper.lfas(city, cycle).unshift("Unassigned")
    get_lfas_info(lfas_emails)
  end

  def locations
    Bootcamper.distinct.order(:city).pluck(:city)
  end

  def page_rows
    %w(15 30 45 60)
  end

  def decision_comments(comment)
    comment && comment.empty? ? "No comment" : comment
  end

  def get_lfas_info(lfas_emails)
    lfas_info = []

    lfas_emails.each do |email|
      name = email.split("@")[0].split(".")
      lfas_info << {
        name: name.each(&:capitalize!).join(" "),
        email: email
      }
    end
    lfas_info
  end

  def get_total_assessed(camper_id)
    Score.get_camper_assessment_count(camper_id)
  end

  def get_total_assessments
    @get_total_assessments ||= Assessment.get_total_assessments
  end

  def get_total_percentage(total_assessed, total_assessments)
    total_assessed = Float(total_assessed)
    total_assessments = Float(total_assessments)
    ((total_assessed * 100) / total_assessments).round(1)
  end

  def get_progress_status(total_percentage)
    if total_percentage > 0 && total_percentage < 50
      "below-average"
    elsif total_percentage >= 50 && total_percentage <= 99
      "average-and-above"
    else
      "completed"
    end
  end
end
