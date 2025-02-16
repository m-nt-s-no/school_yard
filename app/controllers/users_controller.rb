class UsersController < ApplicationController
  before_action :set_user, only: %i[ show events groups messages calendar ]

  def index
    @users = User.all
  end

  def show
  end

  def events
  end

  def groups
  end

  def messages
  end

  def calendar
    start_date = Date.today.to_date
    @my_calendar = @user.calendar.where(starts_at: start_date.beginning_of_month..start_date.end_of_month)
  end

  private

  def set_user
    if params[:name]
      @user = User.find_by!(name: params.fetch(:name))
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
