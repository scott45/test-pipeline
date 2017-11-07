class BootcamperDecisionReason < ApplicationRecord
  belongs_to :bootcamper, foreign_key: "camper_id"
  belongs_to :decision_reason

  validates :camper_id, presence: true
  validates :decision_stage, presence: true
  validates :decision_reason_id, presence: true

  def self.save_reasons(camper_id, stage, reasons_ids)
    delete_stage_reasons(camper_id, stage)
    if reasons_ids

      reasons_ids.each do |reason_id|
        create(
          camper_id: camper_id,
          decision_stage: stage,
          decision_reason_id: reason_id
        )
      end
    end
  end

  def self.delete_bootcamper_reasons(camper_id, stage = nil)
    if stage
      delete_stage_reasons(camper_id, stage)
    else
      bootcamper_reasons_ids = where(camper_id: camper_id)
      delete bootcamper_reasons_ids
    end
  end

  def self.delete_stage_reasons(camper_id, stage)
    stage_reasons_ids = get_ids(camper_id, stage)

    if stage_reasons_ids
      delete stage_reasons_ids
    end
  end

  def self.get_ids(camper_id, stage)
    bootcamper_reasons_ids = where(
      camper_id: camper_id,
      decision_stage: stage
    )

    unless bootcamper_reasons_ids.empty?
      bootcamper_reasons_ids.pluck(:id)
    end
  end
end
