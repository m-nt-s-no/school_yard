class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show destroy ]
  # NOTE: Nice clean controller
  
  # GET /messages/1 or /messages/1.json
  def show
    authorize @message
  end

  # GET /messages/new
  def new
    @message = Message.new
    authorize @message
    if current_user.role == "guardian"
      @allowed_recipients = User.where(role: "teacher")
    else
      @allowed_recipients = User.where.not(id: current_user.id)
    end
  end

  # POST /messages or /messages.json
  def create
    @message = Message.new(message_params)
    @message.sender = current_user
    authorize @message

    respond_to do |format|
      if @message.save
        format.html { redirect_back fallback_location: root_path, notice: "Message was successfully created." }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    authorize @message
    @message.destroy!

    respond_to do |format|
      format.html { redirect_to my_messages_path(current_user.slug), notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:sender_id, :recipient_id, :content)
    end
end
