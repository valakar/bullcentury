ActiveAdmin.register Project do

  permit_params :state
  scope :set_for_publish

  index do
    selectable_column
    id_column
    column :name
    column :funding_duration_in_days
    column :funding_goal
    column :state do |project|
      (status_tag project.state, (project.state == "set_for_publish" ? :warning : (project.state == "published" ? :ok : :error)))
    end
  end

  filter :name
  filter :state
  filter :funding_duration_in_days
  filter :funding_goal


# type
# :admin
# :moderator

  form do |f|
    f.inputs "Admin Details" do
      f.input :state, :label => "Change status", :as => :select, :collection => [["Published", "published"], ["Rejected", "rejected"]]
    end
    f.actions
  end

action_item( :only => :show ) { (link_to "accept", publish_admin_project_path(:id => project), :method => :get) if current_admin_user.role == "moderator" }
action_item( :only => :show ) { (link_to "decline", decline_admin_project_path(:id => project), :method => :get) if current_admin_user.role == "moderator" }

  show do |project|
    attributes_table do
      row :state do |project|
        (status_tag project.state, (project.state == "set_for_publish" ? :warning : (project.state == "published" ? :ok : :error)))
      end
      row :name
      row :description
      row :tweet
    end
  end

  member_action :publish, :method => :get do
    if current_admin_user.role == "moderator"
      @project = Project.find params[:id]
      t = Time.now
      start_at = Time.new(t.year, t.month, t.day + 1 )
      @project.delay( { run_at: start_at} ).publish
    else
      redirect_to admin_projects_path
    end
  end

  member_action :decline, :method => :get do
    if current_admin_user.role == "moderator"
      @project = Project.find params[:id]
      t = Time.now
      start_at = Time.new(t.year, t.month, t.day + 1 )
      @project.delay( { run_at: start_at} ).reject
    else
      redirect_to admin_projects_path
    end
  end

end
