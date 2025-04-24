class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[ destroy ]

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
    authorize @enrollment
  end

  # POST /enrollments or /enrollments.json
  def create
    @enrollment = Enrollment.new(enrollment_params)
    authorize @enrollment

    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to enrollment_url(@enrollment), 
                      notice: "Enrollment was successfully created." }
        format.json { render :show, status: :created, location: @enrollment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, 
                      status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    authorize @enrollment
    @enrollment.destroy!

    respond_to do |format|
      format.html { redirect_to edit_group_path(@enrollment.group), 
                    notice: 'Member was successfully disenrolled.'}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def enrollment_params
      params.require(:enrollment).permit(:group_id, :user_id)
    end
end
