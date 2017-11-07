class IndexFacade
  attr_reader :query_params, :lfas, :cycles

  def initialize(params = nil)
    @query_params = get_query_object(params)
    @search_params = params[:search]
    @lfas = Bootcamper.lfas(
      @query_params[:city], @query_params[:cycle]
    )
    @cycles = Bootcamper.where(city: @query_params[:city].strip).
              map(&:cycle).to_set.to_a
  end

  def get_query_object(params)
    page_size = (params[:size] || 15).to_i
    filter_params = {
      city: params["city"] || "All",
      cycle: params["cycle"] || "All",
      week_one_lfa: params["week_one_lfa"] || "All",
      week_two_lfa: params["week_two_lfa"] || "All",
      decision_one: params["decision_one"] || "All",
      decision_two: params["decision_two"] || "All",
      page: params["page"] || 1
    }
    filter_params[:num_pages] = get_number_of_pages(page_size, filter_params)
    filter_params[:page_size] = page_size

    filter_params
  end

  def get_number_of_pages(page_size, filter_params)
    data = get_bootcampers(filter_params).length
    if (data % page_size).zero?
      (data / page_size)
    else
      (data / page_size) + 1
    end
  end

  def get_bootcampers(query_params)
    query = {}
    data = %w(city decision_one decision_two cycle week_one_lfa week_two_lfa)
    data.each do |filter|
      filter = filter.parameterize.to_sym
      if query_params[filter] != "All" && query_params[filter]
        query[filter] = query_params[filter]
      end
    end
    Bootcamper. where(query).order("created_at DESC")
  end

  def table_data
    return Bootcamper.search(@search_params.to_s.downcase) if @search_params
    get_bootcampers @query_params
  end

  def offset
    (@query_params[:page].to_i * @query_params[:page_size].to_i) -
      @query_params[:page_size].to_i
  end

  def phase
    @phase = Phase.first.id
  end

  def statuses(decision = nil)
    decision_status = {
      decisions:
        ["In Progress",
         "Rejected",
         "Level Up",
         "Dropped Out",
         "Try Again",
         "Accepted"],
      decision_one: ["Advanced"],
      decision_two: ["Not Applicable"]
    }
    if decision == "decision1"
      decision_status[:decisions].insert(4, decision_status[:decision_one][0])
    elsif decision == "decision2"
      decision_status[:decisions]
    else
      decision_status[:decisions] +
        decision_status[:decision1] +
        decision_status[:decision2]
    end
  end
end
