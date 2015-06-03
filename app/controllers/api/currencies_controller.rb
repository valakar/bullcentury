class Api::CurrenciesController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  def index
    render json: currencies
  end

  private
  def currencies
  	@currencies ||= Currency.all  
  end
end