class DecisionReasonController < ApplicationController
  def get_status_reasons
    bootcamper = Bootcamper.find(params[:id])
    bootcamper_stage_reasons = bootcamper.get_decision_reasons(params[:stage])
    status_reasons = DecisionStatus.get_reasons(params[:status])

    stage_and_bootcamper_reasons = {}

    status_reasons.each do |reason|
      if bootcamper_stage_reasons.include?(reason)
        # bootcamper has this reason
        stage_and_bootcamper_reasons[reason] = "1"
      else
        # bootcamper does not have the reason
        stage_and_bootcamper_reasons[reason] = "0"
      end
    end

    render json: stage_and_bootcamper_reasons
  end
end
