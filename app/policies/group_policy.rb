class GroupPolicy < ApplicationPolicy
  attr_reader :user, :group

  def initialize(user, group)
    @user = user
    @group = group
  end

  def show?
    true
  end

  #only teachers can create groups
  def new?
    @user.role == "teacher"
  end

  def show_members?
    @user.role == "teacher" || @group.members.include?(@user)
  end

  #only a group's leader can edit/update/destroy the group
  def edit?
    @user == @group.leader
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
