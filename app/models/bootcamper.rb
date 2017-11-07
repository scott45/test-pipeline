require "fancy_id"
require "roo"

class Bootcamper < ApplicationRecord
  self.primary_key = :camper_id
  validates :camper_id, presence: true, uniqueness: true
  validates :week_one_lfa, presence: true
  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :gender, presence: true, acceptance: { accept: %w(Male Female) }
  validates :country, presence: true
  validates :city, presence: true
  validates :cycle, presence: true
  validates_uniqueness_of :email, scope: :cycle

  belongs_to :program
  has_many :scores,
           class_name: "Score",
           primary_key: "camper_id",
           foreign_key: "camper_id"

  has_many :bootcamper_decision_reasons,
           class_name: "BootcamperDecisionReason",
           primary_key: "camper_id",
           foreign_key: "camper_id"

  has_many :decision_reasons,
           class_name: "DecisionReason",
           foreign_key: "camper_id",
           through: "bootcamper_decision_reasons"

  def self.generate_camper_id
    generate_id
  end

  def self.update_campers_progress(data)
    camper_score = update_scores(data)
    Bootcamper.find_by(camper_id: data[:id]).update(
      progress_week1: camper_score[:week1_progress],
      progress_week2: camper_score[:week2_progress],
      overall_average: camper_score[:overall_average],
      week1_average: camper_score[:week1_average],
      week2_average: camper_score[:week2_average],
      project_average: camper_score[:project_average],
      value_average: camper_score[:framework_averages][0],
      output_average: camper_score[:framework_averages][1],
      feedback_average: camper_score[:framework_averages][2]
    )
  end

  def self.search(search_term)
    criteria = %w[lower(email)].
               push("lower(first_name) || ' ' || lower(last_name)")
    query = criteria.map { |value| value + " ILIKE :search_term" }.join(" OR ")
    where(query, search_term: "%#{search_term}%")
  end

  def name
    "#{first_name} #{last_name}"
  end

  def self.lfas(city, cycle)
    Bootcamper.
      where(city: city.strip, cycle: cycle.strip).
      map(&:week_one_lfa).to_set.to_a
  end

  def self.update_scores(data)
    score = {}
    score[:week1_progress] = progress_percentage(
      data[:week1_score],
      data[:week1_total]
    )
    score[:week2_progress] = progress_percentage(
      data[:week2_score],
      data[:week2_total]
    )
    score[:overall_average] = Score.overall_average(data[:id])
    score[:project_average] = Score.final_project_average(data[:id])
    score[:framework_averages] = Score.framework_averages(data[:id])
    score
  end

  def self.progress_percentage(score, total)
    (score * 100 / total).round
  end

  def get_decision_reasons(decision_stage)
    bootcamper_decision_reasons.
      where(decision_stage: decision_stage).
      map { |value| value.decision_reason.reason }
  end
end
