module CamperDataService
  extend self
  def get_camper_data(serial_number, camper)
    [
      serial_number, camper.name,
      camper.email, camper.gender, camper.city,
      camper.cycle, camper.week_one_lfa,
      camper.week_two_lfa, camper.decision_one,
      format_decision_reasons(camper, 1), camper.decision_one_comment,
      camper.decision_two, format_decision_reasons(camper, 2),
      camper.decision_two_comment, camper.overall_average,
      camper.week1_average, camper.week2_average,
      camper.project_average, camper.value_average,
      camper.output_average, camper.feedback_average
    ]
  end

  def get_camper_score(camper_id)
    assessments = AssessmentService.get_assessment_json
    camper_assessment_score = []

    assessments.each_key do |phase_name|
      assessments[phase_name].each do |assessment|
        camper_assessment_score << get_assessment_score(
          phase_name,
          assessment,
          camper_id
        )
      end
    end
    camper_assessment_score
  end

  def format_decision_reasons(camper, decision_stage)
    camper.
      get_decision_reasons(decision_stage).
      join(", ")
  end

  private

  def get_assessment_score(phase_name, assessment_name, camper_id)
    phase_id = Phase.find_by(name: phase_name).id
    camper_assessment = Assessment.find_by(name: assessment_name)
    assessment_id = camper_assessment.id
    bootcamper_data = Score.find_by(
      assessment_id: assessment_id,
      phase_id: phase_id,
      camper_id: camper_id
    )
    if bootcamper_data
      bootcamper_data.score
    else
      "-"
    end
  end
end
