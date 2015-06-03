ActiveAdmin.register AdminUser do
  permit_params :role, :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
#    actions :if => proc{|e| current_admin_user.role == "admin"}
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    if current_admin_user.role == "admin"
      f.inputs "Admin Details" do
        f.input :role, :label => "Choose role", :as => :select, :collection => [["admin", "admin"], ["moderator", "moderator"]]
        f.input :email
        f.input :password
        f.input :password_confirmation
      end
      f.actions
   else
      div do "You have no rights to do that" end
    end
  end

  controller do
    def delete
      @user = AdminUser.find params[:id]
      if current_admin_user.role == "admin" and current_admin_user.id = @user
        @user.destroy
      else
        redirect_to admin_users_path
      end
    end
  end

end
