class IndexController < ApplicationController
  def index
    @dashboard = IndexFacade.new(params)
    data_sheet = BootcampersCsvService

    populate_dashboard

    respond_to do |format|
      format.js
      format.html
      format.csv do
        send_data data_sheet.generate_report(
          city: params[:city],
          cycle: params[:cycle],
          decision_one: params[:decision_one],
          decision_two: params[:decision_two],
          week_one_lfa: params[:week_one_lfa],
          week_two_lfa: params[:week_two_lfa]
        ), filename: "bootcampers-#{Date.today}.csv"
      end
      format.json { render json: @dashboard }
    end
  end

  private

  def populate_dashboard
    set_page_size
    @campers = []
    @dashboard.table_data.map do |camper|
      @campers << camper
    end
    sort_option = get_sort_option
    @campers = sort_campers(@campers, params[:order], sort_option)
    @campers = Kaminari.paginate_array(@campers).
               page(params[:page]).per(cookies[:size])
  end

  def set_page_size
    if cookies[:size].nil? || params[:size]
      cookies[:size] = params[:size] || 15
    end
  end

  def get_sort_option
    case params[:sort]
    when "name" then "first_name"
    when "values" then "value_average"
    when "output" then "output_average"
    when "feedback" then "feedback_average"
    when "final_project_average" then "project_average"
    when "overall_average" then "overall_average"
    else "created_at"
    end
  end

  def sort_campers(campers, sort_order, sort_option)
    if sort_order == "asc"
      campers.sort_by { |camper| camper[sort_option] }
    else
      campers.sort_by { |camper| camper[sort_option] }.reverse
    end
  end
end
