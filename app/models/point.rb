class Point < ApplicationRecord
  has_many :metrics
  validates :value, presence: true, uniqueness: true
  validates :context, presence: true, uniqueness: true
end
