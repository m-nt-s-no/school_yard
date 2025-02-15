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
    @my_calendar = @user.calendar.where(starts_at: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
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
