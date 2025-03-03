class MessagePolicy < ApplicationPolicy
  attr_reader :user, :message

  def initialize(user, message)
    @user = user
    @message = message
  end

  #only senders/recipients of messages can view them
  def show?
    @user == @message.sender || @user == @message.recipient
  end

  def new?
    true
  end

  def create?
    new?
  end

  def destroy?
    show?
  end
end
