class Api::CategoriesController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  def index
    render json: categories
  end

  private
  def categories
  	@categories ||= Category.all  
  end
end