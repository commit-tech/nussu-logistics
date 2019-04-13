# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user
  
    can :manage, User, id: user.id
    cannot %i[create destroy allocate_roles update_roles show_full], User

    user.roles.each { |role| __send__(role.name.downcase) }
  end

  def admin
    can %i[allocate_roles update_roles destroy], :all
  end
end
