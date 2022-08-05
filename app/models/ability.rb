# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    return if user.blank?

    can %i(update destroy), Comment, {user: user,
                                      report: {report_status: :unverifyed}}
    can :create, Comment, {report_status: :unverifyed}
    can :read, Department, {relationships: {user: user}}
    can :read, Notify, user: user
    can :update, Relationship, {user: user, role_type: :manager}
    can :read, Relationship
    can %i(read approve), Report, {department:
        {relationships: user.relationships.manager}}
    can :read, Report, {from_user: user}
    can %i(update destroy), Report, {user: user, report_status: :unverifyed}
    can %i(read update), User, {user: user}
    can :create, Report
    return unless user.admin?

    can :manage, :all
  end
end
