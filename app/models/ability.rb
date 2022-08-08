# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    return if user.blank?

    can %i(update destroy), Comment, {user: user,
                                      report: {report_status: :unverifyed}}
    can :create, Comment, {report_status: :unverifyed}
    can :read, Department, user: user
    can :read, Notify, user: user
    can :update, Relationship, {user: user, role_type: :manager}
    can :read, Relationship, {user: user}
    can :read, Report, {user: user}
    can :read, Report, {department: {relationships: {user: user,
                                                     role_type: :manager}}}
    can %i(update destroy), Report, {user: user, report_status: :unverifyed}
    can %i(read update), User, {user: user}
    return unless user.admin?

    can :manage, :all
  end
end
