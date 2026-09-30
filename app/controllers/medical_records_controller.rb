class MedicalRecordsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @medical_records = @medical_records.includes(:patient, :doctor_profile, :appointment)
  end

  def show
  end

  def new
    @medical_record.patient_id = params[:patient_id] if params[:patient_id].present?
    @medical_record.appointment_id = params[:appointment_id] if params[:appointment_id].present?
    @medical_record.doctor_profile = current_user.doctor_profile if current_user.doctor?
    @medical_record.doctor_profile_id = params[:doctor_profile_id] if params[:doctor_profile_id].present? && !current_user.doctor?
  end

  def create
    @medical_record.doctor_profile = current_user.doctor_profile if current_user.doctor?

    if @medical_record.save
      redirect_to @medical_record, notice: 'Medical record was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @medical_record.update(medical_record_params)
      redirect_to @medical_record, notice: 'Medical record was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medical_record.destroy
    redirect_to medical_records_path, notice: 'Medical record was successfully destroyed.'
  end

  private

  def medical_record_params
    params.require(:medical_record).permit(:patient_id, :doctor_profile_id, :appointment_id, :diagnosis, :description)
  end
end
