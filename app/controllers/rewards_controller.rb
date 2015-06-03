class RewardsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @reward = Reward.new :project_id => params[:project_id]
  end

  def create
    @reward = Reward.new(reward_params)
    if @reward.save
      @project = Project.find(@reward.project.id)
      redirect_to @project
    else
      render 'new'
    end
  end

  def index
    @rewards = Reward.find_by_project_id(params[:project_id])
  end

  def edit
    @reward = Reward.find(params[:id])
  end

  def update
    @reward = Reward.find(params[:id])
    if @reward.update(params[:reward].permit(:per_amount, :description, :image,))
      if params[:reward][:delete_image] == "1"
        @reward.remove_image!
        @reward.save
        puts "DELETING"
      end
      @project = Project.find(@reward.project.id)
      redirect_to @project
    else
      render 'edit'
    end
  end

  def destroy
    @reward = Reward.find(params[:id])
    @reward.destroy

    redirect_to projects_path
  end

  private

  def reward_params
    params.require(:reward).permit(:per_amount, :description, :image, :remote_image_url, :project_id)
  end
end
