module CriteriaHelper
  def criteria_details
    render json: {
      frameworks: Framework.all,
      is_admin: helpers.admin?,
      criteria: Criterium.all.as_json(
        include: { frameworks: { only: %i(name id) } }
      )
    }
  end
end
