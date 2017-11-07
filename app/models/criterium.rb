class Criterium < ApplicationRecord
  has_many :framework_criteria
  has_many :frameworks, through: :framework_criteria
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
end
