class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]

  # GET /events or /events.json
  def index
    @events = Event.all
    authorize @event
  end

  # GET /events/1 or /events/1.json
  def show
    authorize @event
  end

  # GET /events/new
  def new
    @event = Event.new
    authorize @event
  end

  # GET /events/1/edit
  def edit
    authorize @event
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    authorize @event

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), 
                      notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    authorize @event
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), 
                      notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    authorize @event
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to my_events_path(current_user.slug),
                    notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def check_conflicts
    if params[:event_id].present?
      proposed_event = Event.find(params[:event_id])
      proposed_event.assign_attributes(starts_at: params[:starts_at], 
                                       ends_at: params[:ends_at])
    else
      proposed_event = Event.new(starts_at: params[:starts_at], 
                                 ends_at: params[:ends_at])
    end

    group = Group.find(params[:group_id])
    group_members = group.members

    conflict_detector = PossibleEventConflictDetector.new(proposed_event, group_members)
    conflicting_member_count = conflict_detector.detect_member_conflicts

    respond_to do |format|
      format.json { render json: { conflict_count: conflicting_member_count } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :group_id, :starts_at, :address, :notes, :ends_at)
    end
end
