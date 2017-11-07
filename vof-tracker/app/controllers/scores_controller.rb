class ScoresController < ApplicationController
  include ProgressReport

  def create
    return unless helpers.admin? || helpers.user_is_lfa?(params[:id])

    unless params[:scores].blank?
      params[:scores].each do |score|
        Score.save_score(score_params(score), params[:id])
      end

      ProgressReport.set_camper_progress params[:id]
      flash[:notice] = "score-success"
    end
  end

  def new
    @bootcamper = Bootcamper.find_by(camper_id: params[:id])
    @form_phase = Phase.first
    @form_assessment = Assessment.first
    render template: "profile/profile"
  end

  private

  def set_total_assessements
    @total_assessments = 0
    Phase.all.each do |phase|
      @total_assessments += phase.assessments.count
    end
  end

  def set_camper_progress
    set_total_assessements
    @camper_scores = Score.where(camper_id: params[:id])
    @score = @camper_scores.count
    Bootcamper.update_campers_progress(params[:id], @score, @total_assessments)
  end

  def score_params(score)
    score.permit(:score, :comments, :assessment_id, :phase_id)
  end
end
