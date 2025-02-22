class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  #if user is a parent, we filter out other parents in the user#show action
  #parents can still see teachers
  def index?
    true 
  end

  def show?
    true
  end

  #users should only see their own events, groups, messages, calendar
  def events?
    user == current_user
  end

  def groups?
    events?
  end

  def messages?
    events?
  end

  def calendar?
    events?
  end
end
