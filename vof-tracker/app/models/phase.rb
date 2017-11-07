class Phase < ApplicationRecord
  has_and_belongs_to_many :assessments, (-> { distinct })
  has_many :scores
  belongs_to :program

  def self.get_criterion_assessments(framework_id)
    Phase.joins(:assessments).where(
      assessments: {
        framework_criterium_id: framework_id
      }
    )
  end
end
