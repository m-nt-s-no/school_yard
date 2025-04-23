class UsersController < ApplicationController
  before_action :set_user, only: %i[ index show update events groups messages calendar ]
  before_action :configure_permitted_parameters, if: :devise_controller?

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

  def update
    authorize @user
    if @user == current_user
      avatar_file = params.fetch("user").fetch("avatar")
      @user.avatar.attach({
        :io => avatar_file.tempfile,
        :filename => avatar_file.original_filename,
        :content_type => avatar_file.content_type
      })
      @user.save
    end

    redirect_to("/#{ @user.slug }")
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

  protected

  def configure_permitted_parameters
    # allow avatar on sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: ["avatar"])
    # allow avatar on account update
    devise_parameter_sanitizer.permit(:account_update, keys: ["avatar"])
  end
end
