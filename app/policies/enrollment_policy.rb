class EnrollmentPolicy < ApplicationPolicy
  attr_reader :user, :enrollment

  def initialize(user, enrollment)
    @user = user
    @enrollment = enrollment
  end

  #only a group's leader can enroll/disenroll members
  def create?
    @user == @enrollment.group.leader
  end

  def destroy?
    create?
  end
end
