class UsersController < ApplicationController
  before_action :set_user, only: %i[ index show events groups messages calendar ]

  def index
    if @user.role == "teacher"
      @users = User.all
    elsif @user.role == "guardian"
      @users = User.where(:role => "teacher") #parents cannot see other parents in directory
    end
    authorize @user
  end

  def show
    authorize @user
  end

  def events
    authorize @user
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

#took out this code, better suited for "admin" role 
=begin
  def calendar
    start_date = Date.today.to_date
    #below code for parent/teacher view
    if current_user.role != "admin"
      @my_calendar = @user.calendar.where(starts_at: start_date.beginning_of_month..start_date.end_of_month)
    else
    #admin view--incl all teachers' events
    #use Set data structure to remove duplicate events (multiple teachers who have same event)
      @my_calendar = Set[]
      teachers = User.where(:role => "teacher")
      teachers.each do |teacher|
        @my_calendar.merge teacher.calendar.where(starts_at: start_date.beginning_of_month..start_date.end_of_month)
      end
    end
  end
=end
