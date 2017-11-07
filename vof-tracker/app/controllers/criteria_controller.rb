class CriteriaController < ApplicationController
  include CriteriaControllerHelper

  before_action :admin?, only: %i[create update]
  before_action :set_criterium,
                except: %i[index create get_framework_criterium_id]
  # include CriteriaHelper

  def create
    @criterium = Criterium.new(criterium_params)
    if has_frameworks?
      if @criterium.save
        set_frameworks
        flash[:notice] = "criterion-success"
      else
        flash[:error] = @criterium.errors.full_messages[0]
      end
    end
  end

  def index
    @criteria = Criterium.all
  end

  def show
    render json: @criterium, include: { frameworks: { only: %i(name id) } }
  end

  def update
    if has_frameworks? && safe_frameworks?
      if @criterium.update_attributes(criterium_params)
        set_frameworks
        flash[:notice] = "update-success"
      else
        flash[:error] = @criterium.reload.errors.full_messages[0]
      end
    end
  end

  def get_json_response(response)
    respond_to do |format|
      format.json { render json: response.to_json }
    end
  end

  def get_criteria
    criteria = Criterium.
               joins(:framework_criteria).
               where(framework_criteria: { framework_id: params[:id] })
    get_json_response criteria
  end

  def get_framework_criterium_id
    framework_criteria_id = FrameworkCriterium.
                            find_by(
                              criterium_id: params[:criterium_id],
                              framework_id: params[:framework_id]
                            ).id
    get_json_response framework_criteria_id
  end

  private

  def set_criterium
    @criterium = Criterium.includes(:frameworks).find(params[:id])
  end

  # Use strong params to get certain properties from criteria table
  def criterium_params
    params.require(:criterium).permit(:name, :description)
  end

  def admin?
    redirect_to content_management_path unless helpers.admin?
  end
end
