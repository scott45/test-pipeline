class ContentManagementFacade
  def initialize
    @frameworks = Framework.all.order("name DESC")
    @framework = Framework.new
    @criteria = Criterium.all.order("id")
    @criterium = Criterium.new
    @assessments = Assessment.includes(:metrics).all
    @assessment = Assessment.new
    Point.all.each { |point| @assessment.metrics.build(point: point) }
  end

  def get_content
    {
      frameworks: @frameworks,
      framework: @framework,
      criteria: @criteria,
      criterium: @criterium,
      assessments: @assessments,
      assessment: @assessment
    }
  end
end
