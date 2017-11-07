class BootcamperFacade
  def initialize(update_params, camper)
    @params = update_params
    @camper = camper
    @camper_id = @camper.camper_id
  end

  def update_decision_reasons
    stage = @params[:decision_stage_reasons].keys.first.to_i
    reasons = @params[:decision_stage_reasons].values.first

    reasons_ids = DecisionReason.get_ids(reasons)
    BootcamperDecisionReason.save_reasons(@camper_id, stage, reasons_ids)
  end

  def get_lfa_and_status
    if @params.key?(:decision_one)
      BootcamperDecisionReason.delete_bootcamper_reasons(@camper_id)
      { status: { decision_one: @params[:decision_one] } }
    elsif @params.key?(:decision_two)
      BootcamperDecisionReason.delete_bootcamper_reasons(@camper_id, 2)
      { status: { decision_two: @params[:decision_two] } }
    elsif @params.key?(:week_one_lfa)
      { lfa: { week_one_lfa: @params[:week_one_lfa] } }
    elsif @params.key?(:week_two_lfa)
      { lfa: { week_two_lfa: @params[:week_two_lfa] } }
    end
  end

  def update_lfa_or_decision_status
    week_status = get_lfa_and_status
    if week_status.key?(:lfa)
      @camper.update(week_status[:lfa])
    elsif week_status.key?(:status)
      if week_status[:status][:decision_one] == "Advanced"
        week_status[:status][:decision_two] = "In Progress"
      elsif week_status[:status].key?(:decision_one)
        week_status[:status][:decision_two] = "Not Applicable"
        week_status[:status][:week_two_lfa] = "Unassigned"
      end
      @camper.update(week_status[:status])
    end
  end
end
