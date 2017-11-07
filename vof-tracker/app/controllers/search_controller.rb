class SearchController < ApplicationController
  def autocomplete
    bootcampers_fullname = Bootcamper.distinct.pluck(:first_name, :last_name).
                           map { |names| names.join(" ") }
    email = Bootcamper.distinct.pluck(:email)
    render json: email + bootcampers_fullname
  end
end
