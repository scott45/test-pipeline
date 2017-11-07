class Assessment < ApplicationRecord
  belongs_to :framework_criterium
  has_one :framework, through: :framework_criterium
  has_and_belongs_to_many :phases, (-> { distinct })
  has_many :scores
  has_many :metrics, -> { order(point_id: :asc) }, inverse_of: :assessment
  accepts_nested_attributes_for :metrics, update_only: true
  validates :framework_criterium_id, presence: true
  validates :name, presence: true, uniqueness: true
  validates :context, presence: true
  validates :description, presence: true

  def self.get_framework_assessments(framework_id)
    Assessment.joins(:framework_criterium).where(
      framework_criteria: {
        framework_id: framework_id
      }
    )
  end

  def self.get_total_assessments
    total_assessments = 0
    Phase.all.each { |phase| total_assessments += phase.assessments.size }
    total_assessments
  end
end
