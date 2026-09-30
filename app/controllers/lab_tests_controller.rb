class LabTestsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @lab_tests = @lab_tests.includes(:patient, :doctor_profile, :lab_test_result)
  end

  def show
  end

  def new
    @lab_test.patient_id = params[:patient_id] if params[:patient_id].present?
    @lab_test.doctor_profile = current_user.doctor_profile if current_user.doctor?
    @lab_test.doctor_profile_id = params[:doctor_profile_id] if params[:doctor_profile_id].present? && !current_user.doctor?
    @lab_test.status = "pending"
  end

  def create
    @lab_test.doctor_profile = current_user.doctor_profile if current_user.doctor?
    @lab_test.requested_at ||= Time.current.to_s
    @lab_test.status ||= "pending"

    if @lab_test.save
      redirect_to @lab_test, notice: 'Lab test request was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @lab_test.update(lab_test_params)
      redirect_to @lab_test, notice: 'Lab test was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lab_test.destroy
    redirect_to lab_tests_path, notice: 'Lab test was successfully destroyed.'
  end

  private

  def lab_test_params
    params.require(:lab_test).permit(:patient_id, :doctor_profile_id, :test_name, :requested_at, :status)
  end
end
