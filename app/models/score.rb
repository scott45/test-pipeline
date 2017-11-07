class Score < ApplicationRecord
  belongs_to :bootcamper, foreign_key: "camper_id"
  belongs_to :assessment
  belongs_to :phase
  validates_presence_of :score, :phase_id, :assessment_id

  def self.save_score(params, camper_id)
    score = Score.find_or_create_by(
      camper_id: camper_id,
      phase_id: params[:phase_id],
      assessment_id: params[:assessment_id]
    ) do |new_score|
      bootcamp_phase = Phase.find(params[:phase_id]).name
      new_score.week = current_week(bootcamp_phase)
      new_score.score = params[:score]
      new_score.comments = params[:comments]
    end

    score.update_attributes(score: params[:score], comments: params[:comments])
  end

  def self.current_week(bootcamp_phase)
    if bootcamp_phase.include?("Bootcamp") ||
       bootcamp_phase.include?("Project Assessment")
      "2"
    else
      "1"
    end
  end

  def self.week_one_total_assessed(camper_id)
    Score.where(camper_id: camper_id, week: 1).count
  end

  def self.week_two_total_assessed(camper_id)
    Score.where(camper_id: camper_id, week: 2).count
  end

  def self.week_one_average(camper_id)
    total_score = Score.where(week: "1", camper_id: camper_id).sum(:score)
    # TODO: The hardcoded value will be re-implemented to a dynamic variable
    total_assessments = 42.0
    (total_score / total_assessments).round(1)
  end

  def self.week_two_average(camper_id)
    total_score = Score.where(week: "2", camper_id: camper_id).sum(:score)
    total_assessments = 16.0
    (total_score / total_assessments).round(1)
  end

  def self.final_project_average(camper_id)
    project_phase = Phase.where(name: "Project Assessment").first
    assessments = project_phase.assessments.pluck(:id)
    total_score = Score.where(
      camper_id: camper_id,
      week: "2", assessment_id: assessments
    ).sum(:score)
    total_assessments = 6.0
    (total_score / total_assessments).round(1)
  end

  def self.get_camper_assessment_count(camper_id)
    Score.where(camper_id: camper_id).count
  end

  def self.overall_average(camper_id)
    camper_score = get_bootcamper_scores(camper_id).sum(:score)
    camper_assessment_count = get_camper_assessment_count(camper_id)
    if camper_score.zero?
      0.0
    else
      (camper_score / camper_assessment_count).round(1)
    end
  end

  def self.get_bootcamper_scores(camper_id)
    Score.where("camper_id = ?", camper_id)
  end

  def self.framework_averages(camper_id)
    framework_averages = []
    vof = ["Values Alignment", "Output Quality", "Feedback"]
    frameworks = Framework.where(name: vof).order("name DESC")

    frameworks.each do |framework|
      framework_scores = framework.scores.
                         select { |score| score.camper_id == camper_id }
      framework_averages << framework.
                            average_score(camper_id, framework_scores.count)
    end

    framework_averages
  end
end
