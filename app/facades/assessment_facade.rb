class AssessmentFacade
  include AssessmentReport

  def initialize(params = nil)
    @id_params = params[:id]
    completed_assessments
  end

  def completed_assessments
    @bootcamper_assessments = Score.get_bootcamper_scores(@id_params)
    @completed_assessments = {}

    Phase.includes(assessments: :framework_criterium).all.each do |phase|
      @completed_assessments[phase.id] = {}
      grouped_assessments = group_assessments_by_framework(phase.assessments)

      grouped_assessments.each do |framework, assessments|
        @completed_assessments[phase.id][framework] = {}
        set_assessed_scores(phase, framework, assessments)
      end
    end

    set_total_assessed
    @completed_assessments
  end

  def set_assessed_scores(phase, framework, assessments)
    group_assessments_by_criterium(assessments).each_key do |criterium|
      @completed_assessments[phase.id][framework][criterium] = {}
    end

    @bootcamper_assessments.each do |scored|
      next unless scored.phase_id == phase.id

      filtered = filter_assessments(assessments, scored)

      filtered.each do |filtered_assessment|
        score = [scored.score, scored.comments]
        id = filtered_assessment.id
        criterium = filtered_assessment.framework_criterium.criterium.name
        @completed_assessments[phase.id][framework][criterium][id] = score
      end
    end
    set_completed_by_framework(phase, framework, assessments.count)
  end

  def set_completed_by_framework(phase, framework, assessments_count)
    count = 0
    @completed_assessments[phase.id][framework].each_value do |assessments|
      count += assessments.count
    end

    completed = count == assessments_count
    @completed_assessments[phase.id][framework][:completed] = completed
  end

  def filter_assessments(assessments, scored)
    assessments.select do |assessment|
      assessment.id == scored.assessment_id
    end
  end

  def set_total_assessed
    completed_by_week = ProgressReport.completed_assessments_by_week(@id_params)
    Phase.
      includes(assessments: [framework_criterium: :framework]).
      all.
      each do |phase|
        grouped_assessments = group_assessments_by_framework(phase.assessments)
        completed = get_completed_status(phase, grouped_assessments)
        @completed_assessments[phase.id][:completed] = completed
      end

    @completed_assessments[:week_one] = completed_by_week[:week_one]
    @completed_assessments[:week_two] = completed_by_week[:week_two]
  end

  def get_completed_status(phase, assessments)
    assessment_count = 0
    assessed_count = 0

    assessments.each do |framework, grouped_assessments|
      grouped_by_criteria = group_assessments_by_criterium(grouped_assessments)
      grouped_by_criteria.each do |criteria, assessments_by_criteria|
        assessed_count +=
          @completed_assessments[phase.id][framework][criteria].count
        assessment_count += assessments_by_criteria.count
      end
    end

    assessment_count == assessed_count
  end
end
