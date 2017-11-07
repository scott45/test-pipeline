# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Phase.all.each do |phase|
  phase.assessments.destroy_all
end

bootcamp_framework_criteria = {
  "Output Quality" => [
    { "Technical Skills" => "Technical Skill Description" },
    { "Team Skills" => "Team Skills Description" }
  ],
  "Values Alignment" => [
    { "EPIC" => "EPIC Description" },
    { "Technology Leader" => "Technology Leader Description" },
    { "Human Empowerment" => "Human Empowerment Description" }
  ],
  "Feedback" => [
    { "Learning Ability" => "Learning Ability Description" },
    { "Self-awareness" => "Self-awareness Description" }
  ]
}

bootcamp_framework_criteria.each do |framework, criteria|
  framework = Framework.find_or_create_by(name: framework)
  criteria.each do |criterium|
    criterium.each do |criterium_name, criterium_description|
      criterium = Criterium.find_or_create_by(name: criterium_name, description: criterium_description)
      FrameworkCriterium.find_or_create_by(framework_id: framework.id, criterium_id: criterium.id)
    end
  end
end

scoring_guide = ScoringGuideService.new
values_alignment_guide = scoring_guide.get_criterion_guide("Values Alignment")
output_quality_guide = scoring_guide.get_criterion_guide("Output Quality")
feedback_guide = scoring_guide.get_criterion_guide("Feedback")

def populate_assessment(framework_criterium_id, assessments, assessment_guide)
  unless assessments.nil?
    assessments.each do |assessment|
      assessment_context = assessment_guide[assessment]["assessmentContext"]
      assessment_description = assessment_guide[assessment]["assessmentDescription"]
      assessment_instance = Assessment.find_or_create_by(
                              name: assessment,
                              framework_criterium_id: framework_criterium_id
                            )
      assessment_instance.update(
        context: assessment_context,
        description: assessment_description
      )
    end
  end
end

FrameworkCriterium.all.each do |framework_criterium|
  populate_assessment(
    framework_criterium.id,
    scoring_guide.get_assessments(
      framework_criterium.criterium.name,
      framework_criterium.framework.name
    ),
    scoring_guide.get_criterion_guide(framework_criterium.framework.name)
  )
end

programs = {
  "Bootcamp" => "fellow selection process"
}

programs.each do |program_name, program_description|
  program_instance = Program.find_or_create_by(name: program_name)
  program_instance.update_attribute("description", program_description)
end

bootcamp_phases = [
  "Learning Clinic",
  "Home Session 1",
  "Home Session 2",
  "Home Session 3",
  "Home Session 4",
  "One Day Onsite",
  "Bootcamp",
  "Project Assessment"
]

program_id = Program.find_by(name: "Bootcamp").id

bootcamp_phases.each do |phase|
  phase_instance = Phase.find_or_create_by(name: phase)
  phase_instance.update_attribute("program_id", program_id)
end

learning_clinic_assessments = [
  "Growth Mindset",
  "Seeks Feedback",
  "Programming Logic",
  "Version Control",
  "GIT",
  "Test-Driven Development",
  "Excellence",
  "Integrity",
  "Collaboration",
  "Commitment",
  "Openness To Feedback",
  "Progress Attempts"
]

home_one_assessments = [
  "Writing Professionally",
  "Object Oriented Programming",
  "Excellence",
  "Passion",
  "Integrity",
  "Commitment"
]

home_two_assessments = [
  "Writing Professionally",
  "HTTP & Web Services",
  "Excellence",
  "Passion",
  "Integrity",
  "Commitment"
]

home_three_assessments = [
  "Writing Professionally",
  "Front-End Development",
  "Excellence",
  "Passion",
  "Integrity",
  "Commitment"
]

home_four_assessments = [
  "Openness To Feedback",
  "Progress Attempts"
]

one_day_assessments = [
  "Relationship Building",
  "Asks Questions",
  "Agile Methodology",
  "Excellence",
  "Passion",
  "Integrity",
  "Commitment",
  "Collaboration",
  "Openness To Feedback",
  "Progress Attempts"
]

bootcamp_assessments = [
  "Adaptability",
  "Motivation and Commitment",
  "Databases",
  "Excellence",
  "Passion",
  "Integrity",
  "Commitment",
  "Collaboration",
  "Openness To Feedback",
  "Progress Attempts"
]

project_assessments = [
  "Version Control",
  "Project Management",
  "Code Syntax Norms",
  "Github Repository",
  "Code Understanding",
  "Test-Driven Development"
]

Assessment.all.each do |assessment|
  if learning_clinic_assessments.include? assessment.name
    phase = Phase.where(name: "Learning Clinic")
    assessment.phases << phase unless assessment.phases.include?(phase)
  end

  if home_one_assessments.include? assessment.name
    phase = Phase.where(name: "Home Session 1")
    assessment.phases << phase unless assessment.phases.include?(phase)
  end

  if home_two_assessments.include? assessment.name
    phase = Phase.where(name: "Home Session 2")
    assessment.phases << phase unless assessment.phases.include?(phase)
  end

  if home_three_assessments.include? assessment.name
    phase = Phase.where(name: "Home Session 3")
    assessment.phases << phase unless assessment.phases.include?(phase)
  end

  if home_four_assessments.include? assessment.name
    phase = Phase.where(name: "Home Session 4")
    assessment.phases << phase unless assessment.phases.include?(phase)
  end

  if one_day_assessments.include? assessment.name
    phase = Phase.where(name: "One Day Onsite")
    assessment.phases << phase unless assessment.phases.include?(phase)
  end

  if bootcamp_assessments.include? assessment.name
    phase = Phase.where(name: "Bootcamp")
    assessment.phases << phase unless assessment.phases.include?(phase)
  end

  if project_assessments.include? assessment.name
    phase = Phase.where(name: "Project Assessment")
    assessment.phases << phase unless assessment.phases.include?(phase)
  end
end

points_values = [0, 1, 2, 3]
points_context = [
  "N/R",
  "Below Expectations",
  "At Expectations",
  "Exceeds Expectations",
]

points_values.each_with_index do |value, index|
  Point.find_or_create_by(
    value: value,
    context: points_context[index]
  )
end

def populate_assessment_metrics(assessment, assessment_metrics)
  assessment_metrics.each do |metric|
    point = Point.find_by_value(metric["type"])
    point_instance = assessment.metrics.find_or_create_by(
                       assessment_id: assessment.id,
                       point_id: point.id
                     )
    point_instance.update_attribute("description", metric["description"])
  end
end

Assessment.all.each do |assessment|
  if assessment.framework_criterium.framework.name == "Feedback" && feedback_guide[assessment.name]
    assessment_metrics = feedback_guide[assessment.name]["scoringContext"]
    populate_assessment_metrics(assessment, assessment_metrics)
  end

  if assessment.framework_criterium.framework.name == "Output Quality" && output_quality_guide[assessment.name]
    assessment_metrics = output_quality_guide[assessment.name]["scoringContext"]
    populate_assessment_metrics(assessment, assessment_metrics)
  end

  if assessment.framework_criterium.framework.name == "Values Alignment" && values_alignment_guide[assessment.name]
    assessment_metrics = values_alignment_guide[assessment.name]["scoringContext"]
    populate_assessment_metrics(assessment, assessment_metrics)
  end
end

decision = DecisionService.new
decision_data = decision.get_decision_data

decision_data.each do |status, reasons|
  decision_status = DecisionStatus.find_or_create_by(status: status)
  
  reasons.each do |reason|
    decision_reason = DecisionReason.find_or_create_by(reason: reason)
    DecisionReasonStatus.find_or_create_by(
      decision_reason_id: decision_reason.id,
      decision_status_id: decision_status.id
    )
  end
end
