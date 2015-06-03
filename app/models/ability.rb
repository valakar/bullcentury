class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    log_in_user = !user.new_record?
    if log_in_user
      can :read, User, :public => true
      can :manage, User, :id => user.id
      can :manage, Project, :user_id => user.id
      can :create, Project
    else
      can :read, Project, [:state => "published", :state => "closed"]
      can :read, User, :public => true
    end

  end
end
