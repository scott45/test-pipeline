class PhasesController < ApplicationController
  def all
    render json: Phase.all
  end

  def program_phases
    render json: Phase.
      where(program_id: Bootcamper.find(params[:id]).program_id).
      order("id")
  end
end
