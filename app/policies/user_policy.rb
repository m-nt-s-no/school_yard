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

  def update?
    user == current_user
  end

  #only group leader can create new events/groups so only they should see the link to do so
  def show_create_link?
    @user.role == "teacher"
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
