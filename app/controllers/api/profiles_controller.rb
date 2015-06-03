class Api::ProfilesController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :update]
  def show
    render json: profile
  end

  def update
    params[:user] = convert_data_uri_to_upload(params[:user])

    profile.update_attributes(profile_params)
    render nothing: true
  end

  private
  def profile
  	@profile ||= User.find(params[:id])
  end

  def profile_params
    params.require(:user).permit(
      :name, 
      :image, 
      :remote_image_url,
      :location_attributes => [:country, :city])
  end
end