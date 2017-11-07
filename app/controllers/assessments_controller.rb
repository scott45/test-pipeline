class AssessmentsController < ApplicationController
  before_action :admin?, only: %i[create update]
  before_action :get_assessment, only: %i[show update get_assessment_metrics]
  include AssessmentReport
  include AssessmentsHelper

  def get_framework_criteria
    assessments_details
  end

  def all
    phase = Phase.includes(assessments: [framework_criterium: :framework]).
            find_by(id: params[:phase_id])
    if phase.nil?
      record_not_found
    else
      grouped_assessments = {}
      group_assessments_by_framework(phase.assessments).
        each do |framework, assessments|
        grouped_assessments[framework] =
          group_assessments_by_criterium(assessments)
      end
      render json: grouped_assessments
    end
  end

  def create
    @assessment = Assessment.new(assessment_params)
    if @assessment.save
      flash[:notice] = "assessment-success"
    else
      error = @assessment.errors.full_messages[0]
      flash[:error] = if error == "Framework criterium can't be blank"
                        "Framework or Criterion can't be blank"
                      else
                        error
                      end
    end
  end

  def get_assessment_metrics
    assessment_metrics = {
      context: @unique_assessment.context,
      description: @unique_assessment.description,
      metrics: @unique_assessment.metrics
    }
    render json: assessment_metrics
  end

  def show
    metrics = @unique_assessment.metrics.order(:point_id)
    all_assessment = {
      id: @unique_assessment.id,
      name: @unique_assessment.name,
      context: @unique_assessment.context,
      description: @unique_assessment.description,
      framework_id: @unique_assessment.framework_criterium.framework_id,
      framework_name: @unique_assessment.framework_criterium.framework.name,
      criterium_id: @unique_assessment.framework_criterium.criterium_id,
      criteria_name: @unique_assessment.framework_criterium.criterium.name,
      framework_criterium_id: @unique_assessment.framework_criterium_id,
      metrics: metrics
    }
    render json: all_assessment
  end

  def update
    if @unique_assessment.update(assessment_params)
      flash[:notice] = "update-success"
    else
      flash[:error] = @unique_assessment.reload.errors.full_messages[0]
    end
  end

  def get_completed_assessments
    assessments = AssessmentFacade.new(params)
    render json: assessments.completed_assessments
  end

  private

  def admin?
    redirect_to content_management_path unless helpers.admin?
  end

  def get_assessment
    @unique_assessment = Assessment.find(params[:id])
  end

  def assessment_params
    params.require(:assessment).
      permit(
        :name,
        :description,
        :framework_criterium_id,
        :context,
        metrics_attributes: %i(description point_id)
      )
  end

  def group_assessments_by_framework(assessments)
    assessments.group_by do |assessment|
      assessment.framework_criterium.framework.name
    end
  end
end
