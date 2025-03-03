class EventPolicy < ApplicationPolicy
  attr_reader :user, :event

  def initialize(user, event)
    @user = user
    @event = event
  end

  def show?
    true
  end

  #only teachers can create events
  def new?
    @user.role == "teacher"
  end

  #only a event's group leader can edit/update/destroy the event
  def edit?
    @user == @event.group.leader
  end

  def create?
    new?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end
end
