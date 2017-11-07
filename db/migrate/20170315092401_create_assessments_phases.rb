class CreateAssessmentsPhases < ActiveRecord::Migration[5.0]
  def change
    create_table :assessments_phases do |t|
      t.belongs_to :assessment, index: true
      t.belongs_to :phase, index: true
    end
  end
end
