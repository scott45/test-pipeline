class Framework < ApplicationRecord
  has_many :framework_criteria
  has_many :criteria, through: :framework_criteria
  has_many :assessments, through: :framework_criteria
  has_many :scores, through: :assessments
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def average_score(camper_id, total_assessments)
    return 0.0 if total_assessments.zero?

    query_params = {
      camper_id: camper_id,
      assessment_id: Assessment.get_framework_assessments(id).map(&:id)
    }
    total_score = Score.where(query_params).sum(:score)
    (total_score / total_assessments).round(1)
  end

  def get_assessments_count(framework_criterium_id)
    framework_assessments_count = 0

    Phase.all.includes(assessments: :framework_criterium).each do |phase|
      framework_assessments_count += phase.assessments.where(
        framework_criterium_id: framework_criterium_id
      ).count
    end
    framework_assessments_count
  end
end
