class FrameworkCriterium < ApplicationRecord
  belongs_to :criterium
  belongs_to :framework
  has_many :assessments
end
