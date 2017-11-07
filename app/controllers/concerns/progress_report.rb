module ProgressReport
  extend ActiveSupport::Concern

  def self.set_camper_progress(camper_id)
    set_total_assessements

    Bootcamper.update_campers_progress(
      id: camper_id,
      week1_score: Score.week_one_total_assessed(camper_id),
      week2_score: Score.week_two_total_assessed(camper_id),
      week1_total: @total_assessment_week1,
      week2_total: @total_assessment_week2
    )
  end

  def self.completed_assessments_by_week(camper_id)
    set_total_assessements

    {
      week_one: {
        assessed: Score.week_one_total_assessed(camper_id),
        total: @total_assessment_week1
      },

      week_two: {
        assessed: Score.week_two_total_assessed(camper_id),
        total: @total_assessment_week2
      }
    }
  end

  def self.set_total_assessements
    @total_assessment_week1 = 0
    @total_assessment_week2 = 0

    Phase.includes(:assessments).all.each do |phase|
      week = Score.current_week(phase.name)
      if week == "1"
        @total_assessment_week1 += phase.assessments.size
      else
        @total_assessment_week2 += phase.assessments.size
      end
    end
  end
end
