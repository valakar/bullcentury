class Api::CountriesController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  def index
    render json: countries
  end

  private
  def countries
  	@countries ||= Country.all  
  end
end