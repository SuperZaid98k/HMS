class TreatmentAssignmentsController < ApplicationController
  before_action :authenticate_user!
  load_resource :medical_record
  load_and_authorize_resource :treatment_assignment, through: :medical_record

  def create
    if @treatment_assignment.save
      redirect_to @medical_record, notice: 'Treatment assigned successfully.'
    else
      redirect_to @medical_record, alert: 'Failed to assign treatment.'
    end
  end

  def destroy
    @treatment_assignment.destroy
    redirect_to @medical_record, notice: 'Treatment assignment removed.'
  end

  private

  def treatment_assignment_params
    params.require(:treatment_assignment).permit(:treatment_id, :started_at, :completed_at, :notes)
  end
end
