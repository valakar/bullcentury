class Api::RewardsController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  def index
    render json: rewards
  end

  def show
    render json: reward
  end

  def create
    params[:reward] = convert_data_uri_to_upload(params[:reward])

    reward = allRewards.create!(reward_params)
    render json: reward
  end

  # def update
  #   @product = Product.find(params[:id])
  #   if @product.update_attributes(product_params)
  #     redirect_to @product
  #   else
  #     render :index
  #   end
  # end

  def update
    params[:reward] = convert_data_uri_to_upload(params[:reward])

    reward.update_attributes(reward_params)
    render nothing: true
  end

  #def delete
  #  render json: product
  #end

  def destroy
     reward.destroy
     render nothing: true
  end

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
  def reward
  	@reward ||= Reward.find(params[:id])
  end

  def rewards
  	# @rewards ||= Reward.find_by_project_id(params[:project_id]) 
  	@rewards ||= Reward.all(:conditions => ["project_id = ?", params[:project_id]])
  end

  def allRewards
    @allRewards ||= Reward.all  
  end

  def reward_params
    params.require(:reward).permit(
      :per_amount, 
      :description, 
      :image, 
      :remote_image_url, 
      :project_id
    )
  end
end