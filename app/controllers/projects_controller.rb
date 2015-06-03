class ProjectsController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :show, :index, :leisure, :media, :art, :crazy, :innovation, :social, :create]

  def new
    @project = Project.new
    @currencies = Currency.all
  end

  def create
    @project = Project.new(project_params)
    if user_signed_in?
      @project.user_id = current_user.id
      if @project.save
        category_ids = [params[:project][:category]] || []
        category_ids.each do |category_id|
          categorization = Categorization.new({:category_id => category_id, :project_id => @project.id})
          categorization.save
        end
        if !current_user.current_project_id
          current_user.current_project_id = @project.id
          current_user.save
        end
        redirect_to edit_project_url(@project.id)
      else
        render 'new'
      end
    # user are not signed in
    else
      #@project.user_id = current_user.id
      if @project.save
        category_ids = [params[:project][:category]] || []
        category_ids.each do |category_id|
          categorization = Categorization.new({:category_id => category_id, :project_id => @project.id})
          categorization.save
        end
        #Присвоить какой-то номер мол в очереди в session и в бд
        # после регистрации на edit c предзаполненными. данными
        session[:new_project_id] = @project.id
        @project.quick = true
        @project.save
        #if !current_user.current_project_id
        #  current_user.current_project_id = @project.id
        #  current_user.save
        #end
        puts "GO GO GO "
        redirect_to new_user_session_path #login/regictrstion
      else
        render 'new'
      end
    end
  end

  def show
    @project = Project.find(params[:id])
    # if @project.can_read? current_user.try(:id)
    if @project.is_published? || @project.is_owner?(current_user.try(:id))
      @project = Project.find(params[:id])

      @pledgedAmount = @project.calc_pledged
      @pledged = @project.calc_pledged_percentage @pledgedAmount
      @new_pledge = PledgeTransaction.new()
    else
      render :file => "#{Rails.root}/public/404.html", :status => :not_found
    end
  end

  def index
    @projects = Project.where(state: 'set_for_publish')
  end

  def edit
    @currencies = Currency.all
    @project = Project.find(params[:id])
    if session[:new_project_id] && (session[:new_project_id].to_i == params[:id].to_i)
      session.delete(:new_project_id)
      @project.user_id = current_user.id
      current_user.current_project_id = @project.id
      current_user.save
      @project.quick = false
      @project.save
    end

    if can?( :manage, @project) and @project.state == "created"
      @project = Project.find(params[:id])
    else
      session[:errors] = "This project can't be modified"
      redirect_to @project
    end
  end

  def update
    @project = Project.find(params[:id])
    puts 'IF START UPDATE'
    if can?( :manage, @project) and @project.state == "created"
      puts 'IF CAN'
      @project = Project.find(params[:id])
      begin
        if @project.update(project_params)
          puts 'IF UPDATE'
          # @project.update_categories params[:project][:category_ids]
          # redirect_to @project
          render 'edit'
        else
          render 'edit'
        end
      rescue ActiveRecord::StatementInvalid => ex
        session[:errors] = "Tweet is to long"
        redirect_to edit_project_path(@project)
      end
    else
      session[:errors] = "This project can't be modified"
      redirect_to @project
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to projects_path
  end

  def publish
    @project = Project.find(params[:id])
    if @project.user_id == current_user.id
      if @project.set_for_publish
        flash[:notice] = "Project has transferred for a review."
        render :show
      else
        session[:errors] = @project.get_validation_errors.values.compact.join('<br/>').html_safe
        begin
          redirect_to :back
        rescue ActionController::RedirectBackError
          render :show
        end
      end
    else
      session[:errors] = "You have no rights to do that."
      begin
        redirect_to :back
      rescue ActionController::RedirectBackError
        redirect_to @project
      end
    end
  end


  def agreement_page
    @project = Project.find(params[:id])
    if @project.user_id == current_user.id
      unless @project.valid_for_publish?
        session[:errors] = @project.get_validation_errors.values.compact.join('<br/>').html_safe
        render :show
      else
        render
      end
    else
      session[:errors] = "You have no rights to do that."
      begin
        redirect_to :back
      rescue ActionController::RedirectBackError
        redirect_to @project
      end
    end
  end

  def popular
    @popular_projects = Project.where(state: 'set_for_publish')
    @popular_projects = Array.new unless @popular_projects
  end

  def successful
    @successful_projects = Project.where(state: 'set_for_publish')
    @successful_projects = Array.new unless @successful_projects
  end

  def leisure
    @category = :leisure
    @projects = Category.find_by_key(@category).projects
    render :action => 'index'
  end

  def media
    @category = :media
    @projects = Category.find_by_key(:media).projects
    render :action => 'index'
  end

  def art
    @category = :art
    @projects = Category.find_by_key(:art).projects
    puts 'TEST   '
    puts @projects
    render :action => 'index'
  end

  def crazy
    @category = :crazy
    @projects = Category.find_by_key(:crazy).projects
    render :action => 'index'
  end

  def innovation
    @category = :innovation
    @projects = Category.find_by_key(:innovation).projects
    render :action => 'index'
  end

  def social
    @category = :social
    @projects = Category.find_by_key(:social_projects).projects
    render :action => 'index'
  end

  private
    def project_params
      #console.log(params) 
      puts params.inspect
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
        :address
      )
    end
end
