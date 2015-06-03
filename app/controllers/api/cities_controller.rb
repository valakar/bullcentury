class Api::CitiesController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  def index
    render json: cities
  end

  def show
  	render json: cities_by_country
  end

  private
  def cities_by_country
  	@cities_by_country ||= City.find_all_by_country_id(params[:id]);
  end

  def cities
  	@cities ||= City.all;
  end
end