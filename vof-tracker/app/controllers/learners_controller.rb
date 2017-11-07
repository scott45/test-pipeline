class LearnersController < ApplicationController
  before_action :redirect_unauthorized_learner
  skip_before_action :redirect_non_andelan

  def index; end
end
