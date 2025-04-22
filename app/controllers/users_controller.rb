class UsersController < ApplicationController
  before_action :set_user, only: %i[ index show events groups messages calendar ]

  def index
    if @user.role == "teacher"
      @q = User.ransack(params[:q])
    elsif @user.role == "guardian"
      #parents cannot see other parents in directory
      @q = User.where(:role => "teacher").ransack(params[:q])
    end
    @users = @q.result
    authorize @user
  end

  def show
    authorize @user
  end

  def events
    authorize @user
    @conflicts = EventConflictDetector.new(@user.calendar).detect_event_conflicts
  end

  def groups
    authorize @user
  end

  def messages
    @received_msgs = @user.received_messages.order(created_at: :desc)
    @sent_msgs = @user.sent_messages.order(created_at: :desc)
    authorize @user
  end

  def calendar
    start_date = Date.today.to_date
    authorize @user
  end

  private

  def set_user
    if params[:slug]
      @user = User.find_by!(slug: params[:slug])
    else
      @user = current_user
    end
  end
end
