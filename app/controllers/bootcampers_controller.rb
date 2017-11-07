class BootcampersController < ApplicationController
  before_action :set_bootcamper, only: [:show]
  include BootcampersHelper

  def index
    redirect_non_admin
  end

  def add
    country = bootcampers_params["country"]
    @city = bootcampers_params["city"].capitalize
    @cycle = bootcampers_params["application_cycle"]
    sheet = SpreadsheetService.new(bootcampers_params[:file])
    data = [country, @city, @cycle, sheet.get_data]

    if valid_data = validate_spreadsheet(sheet, data)
      sanitized_data = valid_data.each do |camper|
        camper[:first_name].capitalize!
        camper[:last_name].capitalize!
      end
      Bootcamper.create sanitized_data
    end
    render :index
  end

  def edit; end

  def show
    @application_phases = Phase.all
    render template: "bootcampers/profile"
  end

  def update
    return unless helpers.admin?
    set_bootcamper

    BootcamperFacade.new(params, @bootcamper).update_lfa_or_decision_status
    respond_to do |format|
      format.json { render json: { message: "status update successful" } }
    end
  end

  def all
    render json: Bootcamper.all
  end

  def validate_spreadsheet(sheet, data)
    @error = {}
    data = sheet.validate_spreadsheet(data)
    if data[:error]
      @error = data
    else
      @error[:error] = false
      valid_data = data[:bootcampers]
    end
    valid_data
  end

  def save_decision_comments
    return unless helpers.user_is_lfa?(params[:id]) || helpers.admin?

    set_bootcamper

    save_decision @bootcamper, decision_params
  end

  def get_decision_comments
    set_bootcamper

    render json: {
      decision_one_comment: @bootcamper[:decision_one_comment],
      decision_two_comment: @bootcamper[:decision_two_comment]
    }
  end

  def save_decision_reasons
    return unless helpers.admin?
    set_bootcamper

    BootcamperFacade.new(params, @bootcamper).update_decision_reasons
    respond_to do |format|
      format.json { render json: { message: "status update successful" } }
    end
  end

  private

  def set_bootcamper
    @bootcamper = Bootcamper.find_by(camper_id: params[:id])
  end

  def bootcampers_params
    params.permit("country", "city", "application_cycle", "file")
  end

  def decision_params
    params.permit(:decision_one_comment, :decision_two_comment)
  end
end
