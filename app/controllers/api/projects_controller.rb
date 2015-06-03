class Api::ProjectsController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  def index
    render json: projects
  end

  def show
    render json: project
  end

  # def create
  #   project = projects.create!(product_params)
  #   render json: project
  # end

  # def update
  #   @product = Product.find(params[:id])
  #   if @product.update_attributes(product_params)
  #     redirect_to @product
  #   else
  #     render :index
  #   end
  # end

  def update
    puts 'UPDATE START'
    params[:project] = convert_data_uri_to_upload(params[:project])
    puts 'params[:project][:image]'
    puts params[:project][:image]
    puts 'UPDATE END'

    project.update_attributes(project_params)
    render nothing: true
  end

  #def delete
  #  render json: product
  #end

  # def destroy
  #    project.destroy
  #    render nothing: true
  # end

  # def new
  #   @product = Product.new
  #   @categories = Category.all
  # end

  # def create
  #   @product = Product.new(product_params)
  #   if @product.save
  #     redirect_to products_path
  #   end
  # end

  # def edit
  #   @product = Product.find(params[:id])
  #   @categories = Category.all
  # end


  



  # def destroy
  #   Product.find(params[:id]).destroy
  #   redirect_to products_path
  # end

  private

  def project
  	@project ||= Project.find(params[:id])
  end

  def projects
  	@projects ||= Project.all  
  end

  

  def project_params
    params.require(:project).permit(
      :name, 
      :description, 
      :tweet, 
      :funding_duration_in_days, 
      :funding_goal, 
      :image, 
      :remote_image_url, 
      :video, 
      :currency_id, 
      :creator_biography, 
      :website, 
      :timeline1, 
      :timeline2, 
      :timeline3, 
      :timeline_date1, 
      :timeline_date2, 
      :timeline_date3,
      :country_id, 
      :city_id,
      :region, 
      :zip, 
      :address,
      :category_ids => []
    )
  end
end