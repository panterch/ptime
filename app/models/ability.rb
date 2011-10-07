class Ability
  include CanCan::Ability

  def initialize(user)
    # Three types of users:
    # 1. User without login: Cannot see or do anything
    # 2. User without admin: Freelancers
    # 3. User with admin: Panter MA

    return unless user  # without login, nothing is authorized

    if user.admin
      can :manage, :all
      cannot :update, Entry do |entry|
        entry.try(:user) != user
      end
      cannot :destroy, Entry do |entry|
        entry.try(:user) != user
      end
      cannot :destroy, User, :id => user.id
      cannot :destroy, MilestoneType
      cannot :destroy, ResponsibilityType

    elsif user
      can :create, Entry
      can :read, Entry do |entry|
        entry.try(:user) == user
      end
      can :update, Entry do |entry|
        entry.try(:user) == user
      end
      can :destroy, Entry do |entry|
        entry.try(:user) == user
      end
      # TODO: This needs refactoring. The reports needs to be generated in the model for that.
      #can :show, Report, :user_id => user.id do |report|
      can :show, Report do |report|
        # only allow access to reports containing the users time entries
        usernames = report.all.collect { |e| e.user.username }.uniq
        (usernames.count == 1) and (usernames.first == user.username)
      end
      can :update, User, :id => user.id
      can :read, User, :id => user.id
    end

    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
