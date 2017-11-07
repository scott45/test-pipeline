class Metric < ApplicationRecord
  belongs_to :point
  belongs_to :assessment, inverse_of: :metrics
  validates :point_id, presence: true
  validates :description, presence: true
  validates :assessment, presence: true
  before_save :check_and_delete_if_exists

  def check_and_delete_if_exists
    Metric.where(assessment_id: assessment_id, point_id: point_id).delete_all
  end
end
