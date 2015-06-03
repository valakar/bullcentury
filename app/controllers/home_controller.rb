class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :how_it_works, :quick_start, :university, :faq, :rules, :company, :mentors, :feedback]

  def index
    @popular_projects = Project.where(state: 'set_for_publish')[0, 5]
    @successful_projects = Project.where(state: 'set_for_publish')[0, 3]

    @popular_projects = Array.new unless @popular_projects
    @successful_projects = Array.new unless @successful_projects
  end

  def how_it_works
  end

  def quick_start
  end

  def university
  end

  def faq
  end

  def rules
  end

  #TODO 
  def company
  end

  #TODO 
  def mentors
    @users = User.all[0, 5]
    @mentors = User.all[0, 3]
    # render json: {:mentors => @mentors}
    respond_to do |format|
      format.json { @mentors }
      format.html { render '/home/mentors' }
    end
  end

  #TODO
  def feedback
  end


end
