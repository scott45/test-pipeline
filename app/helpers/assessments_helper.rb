module AssessmentsHelper
  def get_assessment_details(assessments)
    assessment_metrics = []
    assessments.each do |assessment|
      assessment_metrics.push(
        assessment: assessment,
        metrics: filter_assessment_metrics(assessment),
        framework: assessment.framework_criterium.framework.name,
        criteria: assessment.framework_criterium.criterium.name
      )
    end
    assessment_metrics
  end

  def get_criteria_framework(criteria)
    criteria_framework = []
    criteria.each do |c|
      criteria_framework.
        push(framework: c.frameworks[0].name, criteria: c.name)
    end
    criteria_framework
  end

  def filter_assessment_metrics(assessment)
    filtered_metric = []
    assessment.metrics.each do |metric|
      filtered_metric.push(
        point: metric.point.value,
        description: metric.description
      )
    end
    filtered_metric
  end

  def assessments_details
    render json: {
      frameworks: Framework.all,
      is_admin: helpers.admin?,
      criteria: Criterium.all.as_json(
        include: { frameworks: { only: %i(name id) } }
      ),
      criterium_frameworks: get_criteria_framework(
        Criterium.includes(:frameworks).all
      ),
      assessments: get_assessment_details(Assessment.includes(:metrics).all)
    }
  end
end
