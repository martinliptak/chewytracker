class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      send(user.role, user)
    else
      unauthenticated(user)
    end
  end

  private

    def unauthenticated(user)
      # can sign up
      can :create, User
    end

    def regular(user)
      # can access dashboard and create meals
      can [:index_owned, :create], Meal

      # can show, edit and remove own meals
      can [:show, :update, :destroy], Meal do |meal|
        meal.user == user
      end

      # can change user settings
      can [:show, :settings, :update], User do |u|
        u == user
      end
    end

    def user_manager(user)
      regular(user) # all from regular

      can :manage, User
      cannot :update_role_of, User

      # cannot destroy self
      cannot :destroy, User do |u|
          u == user
      end
    end

    def admin(user)
      user_manager(user)

      can :manage, Meal

      # can change user roles
      can :update_role_of, User
    end
end
