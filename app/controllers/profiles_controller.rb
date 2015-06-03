class ProfilesController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :update, :dashboard]

  def index
    @profiles = User.public_profiles
  end

  def show
    @profile = User.find(params[:id])
    @project =  @profile ? @profile.current_project : nil
    @closed_projects = @profile ? @profile.closed_projects : []
  end

  def dashboard
    puts "Bugaga"

    @profile = current_user
    @project =  @profile ? @profile.current_project : nil
    @closed_projects = @profile ? @profile.closed_projects : []
    if session[:new_project_id]
      redirect_to edit_project_url(session[:new_project_id])
    else
      render action: 'show'
    end
  end

  def edit
    user = User.find_by_id params[:id]
    if can?(:manage, user)
      @user = user
      @location = user.location || Location.new
    else
      flash[:error] = "You have no rights to do that"
      redirect_to root_path
    end
  end

  def update
    @user = User.find_by_id profile_params[:id]
    user_params = profile_params
    puts '      START UPDATE!'
    puts profile_params
    if can?(:manage, @user)
      puts '      CAN MANAGE'
      if(profile_params.include?(:email) or profile_params.include?(:password))
        puts '      INCLUDE EMAIL AND PASSWORD'
        if @user.valid_password?(profile_params[:old_password])
          if user_params[:password] == user_params[:password_confirmation]
            @user.password = user_params[:password] if (user_params[:password] and (!user_params[:password].blank?))
            @user.email = user_params[:email] if (user_params[:email] and (user_params[:email] != @user.email))
            if @user.save 
              flash[:notice] = "Update was successful" 
              redirect_to root_path
            else
              @email_errors = @user.errors.full_messages
              flash[:error] = "Something went wrong" 
              render :edit #redirect_to edit_profile_path(:id => profile_params[:id])
            end
          else
            flash[:error] = "Password and password_confirmation are not equal" 
            @email_errors = ["Password and password_confirmation are not equal"] + @user.errors.full_messages
            render :edit# redirect_to edit_profile_path(:id => profile_params[:id])
          end
        else
          flash[:error] = "Old password invalid" 
          @email_errors = @user.errors.full_messages + ["Old password invalid" ]
          render :edit#edit_profile_path(:id => profile_params[:id])
        end
      else
        puts '      NOT INCLUDE EMAIL AND PASSWORD'
        if @user.update_attributes(profile_params)
          puts '      UPDATE ATTRIBUTES'
          flash[:notice] = "Update was successful"
          respond_to do |format|
              format.html {redirect_to profile_path(@user)}
              format.js   {
                render js: <<-endjs
                  alert('Update was successful!');
                endjs
              }
          end

        else
          puts '      UPDATE ATTRIBUTES - WRONG'
          flash[:error] = "Something went wrong" 
          @errors = @user.errors.full_messages

          format.js do
            render js:
              alert('Something went wrong!');
            endjs
          end
          render :edit #edit_profile_path(:id => profile_params[:id])
        end
      end
    else
      puts '      CAN NOT! MANAGE'
      flash[:error] = "You have no rights to do that"
      redirect_to root_path
    end
  end

  def profile_management
    user = User.find_by_id current_user.id
    if can?(:manage, user)
      @user = user
      # @location = user.location || Location.new
      @sexes  = [['Not known', '0'], ['Male', '1'], ['Female', '2'], ['Not applicable', '9']]
      # @cities = City.all
      @countries = Country.all
      @cities = City.where("country_id = ?", user.country_id)
      # @cities = City.where("country_id = ?", Country.first.id)

    else
      flash[:error] = "You have no rights to do that"
      redirect_to root_path
    end
  end

  def receive_money
    @projects = current_user
    .projects.select(
      'id,
      name,
      created_at,
      funding_duration_in_days,
      state,
      funding_goal,
      country_id,
      currency_id'
    )
    .where("projects.state = 'set_for_publish'")

    @projects = Array.new unless @projects
  end

  #temp
  def receive_money_success
    puts '__________ PROJECTS ID FOR USER'
    user_projects = current_user.projects.select(:id).map { |p| p.id.to_i}

    if user_projects.include? params[:id].to_i
      @project = Project.find(params[:id])
    else
      # TODO If project don't belong to current user
      puts '__________ ACCESS DENIAD'
    end

  end

  def invest_project
    @inveted_projects = PledgeTransaction
    .joins(
      'LEFT JOIN projects ' +
      'ON projects.id = pledge_transactions.project_id'
    )
    .joins(
      'LEFT JOIN currencies ' +
      'ON currencies.id = pledge_transactions.currency_id'
    )
    .where(user_id: current_user.id)
    .select(
      'pledge_transactions.id as transaction_id, ' +
      'pledge_transactions.amount, ' +
      'projects.id as id, ' +
      'projects.name as name, ' +
      'projects.state as state, ' +
      'projects.created_at as created_at, ' +
      'currencies.sign as sign'
    )
    @inveted_projects = Array.new unless @inveted_projects

    @projects_contacts = PledgeTransaction
    .where(user_id: current_user.id)
    .joins(
      'LEFT JOIN projects ' +
        'ON projects.id = pledge_transactions.project_id'
    )
    .joins(
      'LEFT JOIN users ' +
      'ON users.id = projects.user_id'
    )
    .joins(
      'LEFT JOIN countries ' +
      'ON countries.id = users.country_id'
    )
    .select(
      'projects.id, ' +
      'projects.name as project_name, ' +
      'users.mobile, ' +
      'users.name as name, ' +
      'users.lastname, ' +
      'users.email, ' +
      'countries.name as country'
    )
    .uniq
    @projects_contacts = Array.new unless @projects_contacts


    # # Create a new file and write to it
    # File.open('logs.txt', 'w') do |f2|
    #   # use "\n" for two lines of text
    #
    #   @contacts.each do |project|
    #     f2.puts ' project_id: ' + project.project_id.to_s +
    #             ' mobile: ' + project.mobile.to_s +
    #             ' name: ' + project.name.to_s +
    #             ' lastname: ' + project.lastname.to_s +
    #             ' email: ' + project.email.to_s +
    #             ' country: ' + project.country.to_s
    #   end
    #   # f2.puts @projects.to_s
    # end
  end

  def refunds
    @refund_projects = PledgeTransaction
    .where(user_id: current_user.id)
    .joins(
      'LEFT JOIN projects
      ON projects.id = pledge_transactions.project_id'
    )
    .joins(
      'LEFT JOIN currencies
      ON currencies.id = projects.currency_id'
    )
    .select(
      'pledge_transactions.id,
      projects.id as project_id,
      projects.name,
      pledge_transactions.amount,
      projects.created_at,
      currencies.sign as currency_sign'
    )
    @refund_projects = Array.new unless @refund_projects
  end

  def my_project
    @profile = User.find(params[:id])
    @project =  @profile ? @profile.current_project : nil
  end

  def promote_project
    @profile = current_user
    @project =  @profile ? @profile.current_project : nil
  end

  def shipping
    # @projects = Project.all[0, 5]
    @shipping_projects = current_user
    .projects
    .joins(
      'LEFT JOIN pledge_transactions
      ON pledge_transactions.project_id = projects.id'
    )
    .select(
      'projects.id,
      projects.name,
      projects.created_at,
      projects.funding_goal,
      sum(pledge_transactions.amount) as sum,
      (sum(pledge_transactions.amount) * 100.0/projects.funding_goal) as funded'
    )
    .group('projects.id')
    @shipping_projects = Array.new unless @shipping_projects

  end

  def activities_report
    @projects = Project.all[0, 5]
    @projects = Array.new unless @projects

    # Invested projects
    @inveted_projects = PledgeTransaction
    .joins(
      'LEFT JOIN projects ' +
        'ON projects.id = pledge_transactions.project_id'
    )
    .joins(
      'LEFT JOIN currencies ' +
        'ON currencies.id = pledge_transactions.currency_id'
    )
    .where(user_id: current_user.id)
    .select(
      'pledge_transactions.id as transaction_id, ' +
        'pledge_transactions.amount, ' +
        'projects.id as id, ' +
        'projects.name as name, ' +
        'projects.state as state, ' +
        'projects.created_at as created_at, ' +
        'currencies.sign as sign'
    )
    @inveted_projects = Array.new unless @inveted_projects

    # Invested projects contacts
    @projects_contacts = PledgeTransaction
    .where(user_id: current_user.id)
    .joins(
      'LEFT JOIN projects ' +
        'ON projects.id = pledge_transactions.project_id'
    )
    .joins(
      'LEFT JOIN users ' +
        'ON users.id = projects.user_id'
    )
    .joins(
      'LEFT JOIN countries ' +
        'ON countries.id = users.country_id'
    )
    .select(
      'projects.id, ' +
        'projects.name as project_name, ' +
        'users.mobile, ' +
        'users.name as name, ' +
        'users.lastname, ' +
        'users.email, ' +
        'countries.name as country'
    )
    .uniq
    @projects_contacts = Array.new unless @projects_contacts


    # Refund project
    @refund_projects = PledgeTransaction
    .where(user_id: current_user.id)
    .joins(
      'LEFT JOIN projects
      ON projects.id = pledge_transactions.project_id'
    )
    .joins(
      'LEFT JOIN currencies
      ON currencies.id = projects.currency_id'
    )
    .select(
      'pledge_transactions.id,
      projects.id as project_id,
      projects.name,
      pledge_transactions.amount,
      projects.created_at,
      currencies.sign as currency_sign'
    )
    @refund_projects = Array.new unless @refund_projects

    # Shipping projects
    @shipping_projects = current_user
    .projects
    .joins(
      'LEFT JOIN pledge_transactions
      ON pledge_transactions.project_id = projects.id'
    )
    .select(
      'projects.id,
      projects.name,
      projects.created_at,
      projects.funding_goal,
      sum(pledge_transactions.amount) as sum,
      (sum(pledge_transactions.amount) * 100.0/projects.funding_goal) as funded'
    )
    .group('projects.id')
    @shipping_projects = Array.new unless @shipping_projects

  end

  def update_cities
    puts 'TEST'
    @cities = City.where("country_id = ?", params[:country_id])
    respond_to do |format|
      format.js
    end
  end

private

  def profile_params
    params.require(:user).permit(
      :id, 
      :name, 
      :lastname,
      :company,
      :birthday,
      :mobile,
      :phone,
      :email,
      :email_backup,
      :sex,
      :image,
      :remote_image_url,
      :old_password,
      :password,
      :password_confirmation,
      :country_id,
      :city_id,
      :zip,
      :address,
      :location_attributes => [:country, :city])
  end
end