class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy ]
  before_action :ensure_current_user_is_group_leader, only: [:destroy, :update, :edit]

  # GET /groups or /groups.json
  def index
    @groups = Group.all
    authorize @group
  end

  # GET /groups/1 or /groups/1.json
  def show
    authorize @group
  end

  # GET /groups/new
  def new
    @group = Group.new
    3.times { @group.enrollments.build }
    authorize @group
  end

  # GET /groups/1/edit
  def edit
    @group.enrollments.build if @group.enrollments.none? { |e| e.new_record? }
    authorize @group
  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params)
    @group.leader_id = current_user.id
    authorize @group

    respond_to do |format|
      if @group.save
        format.html { redirect_to group_url(@group), notice: "Group was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    authorize @group
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_url(@group), notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    authorize @group
    @group.destroy!

    respond_to do |format|
      format.html { redirect_to my_groups_path(current_user.name), notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only a group's leader can destroy, update, or edit a group
    def ensure_current_user_is_group_leader
      if current_user != @group.leader
        redirect_to group_url(@group), alert: "You're not authorized for that."
      end
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:name, enrollments_attributes: [:user_id, :_destroy])
    end
end
