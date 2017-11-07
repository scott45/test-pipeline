class ProfileController < ApplicationController
  before_action :set_application_phase

  def show
    set_bootcamper_and_phases

    @grades = []
    @assessments.count.times do
      @grades << Score.new
    end
    render template: "profile/profile"
  end

  def set_application_phase
    @phase = Phase.find_by(id: params[:phase])

    if @phase.nil?
      record_not_found
    else
      @assessments = @phase.assessments
      @grouped_data = group_assessments_by_framework
    end
  end

  private

  def set_bootcamper_and_phases
    @bootcamper = Bootcamper.find_by(camper_id: params[:id])
    @application_phases = Phase.all
  end

  def group_assessments_by_framework
    result = {}
    @criteria = {}

    @assessments.each do |assessment|
      criterium = Criterium.find(assessment.framework_criterium.criterium.id)

      unless result[criterium.name]
        result[criterium.name] = []
      end

      unless @criteria[criterium.name]
        @criteria[criterium.name] = []
      end

      if @criteria[criterium.name].blank?
        @criteria[criterium.name] << criterium.id
      end

      result[criterium.name] << assessment
    end

    result
  end
end
