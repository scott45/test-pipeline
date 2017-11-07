class DecisionReason < ApplicationRecord
  has_many :bootcamper_decision_reasons,
           class_name: "BootcamperDecisionReason",
           foreign_key: "decision_reason_id"

  has_many :bootcampers,
           class_name: "Bootcamper",
           foreign_key: "decision_reason_id",
           through: "bootcamper_decision_reasons"

  has_many :decision_reason_statuses

  has_many :decision_statuses, through: :decision_reason_statuses

  validates :reason, presence: true, uniqueness: { case_sensitive: false }

  def self.get_ids(reasons)
    reasons = DecisionReason.where(reason: reasons)
    unless reasons.empty?
      reasons.pluck(:id)
    end
  end
end
