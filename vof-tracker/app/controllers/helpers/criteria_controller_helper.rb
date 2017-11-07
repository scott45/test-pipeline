module CriteriaControllerHelper
  def has_frameworks?
    if params[:frameworks].nil?
      flash[:error] = "Please select at least one framework"
      return false
    end
    @framework_ids = params[:frameworks].map!(&:to_i)
    @removed_ids = @criterium.frameworks.map(&:id) - @framework_ids
    @new_ids = @framework_ids - @criterium.frameworks.map(&:id)
    true
  end

  def safe_frameworks?
    unless removed_has_no_outputs?
      flash[:error] = "Some outputs will be affected by "\
        "removing that framework"
      return false
    end
    true
  end

  def removed_has_no_outputs?
    @removed_ids.none? do |id|
      Assessment.joins(:framework_criterium).where(
        framework_criteria: {
          framework_id: id,
          criterium_id: @criterium.id
        }
      ).count > 0
    end
  end

  def set_frameworks
    remove_frameworks unless @removed_ids.empty?
    @new_ids.each do |id|
      FrameworkCriterium.find_or_create_by(
        framework_id: id,
        criterium_id: @criterium.id
      )
    end
    @criterium.frameworks.reload
  end

  def remove_frameworks
    @removed_ids.each do |id|
      FrameworkCriterium.where(
        framework_id: id,
        criterium_id: @criterium.id
      ).destroy_all
    end
  end
end
