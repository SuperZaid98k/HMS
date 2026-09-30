class PrescriptionsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @prescriptions = @prescriptions.includes(:patient, :doctor_profile, :medical_record)
  end

  def show
  end

  def new
    @prescription.patient_id = params[:patient_id] if params[:patient_id].present?
    @prescription.medical_record_id = params[:medical_record_id] if params[:medical_record_id].present?
    @prescription.doctor_profile = current_user.doctor_profile if current_user.doctor?
    @prescription.doctor_profile_id = params[:doctor_profile_id] if params[:doctor_profile_id].present? && !current_user.doctor?
    @prescription.prescription_items.build if @prescription.prescription_items.empty?
  end

  def create
    @prescription.doctor_profile = current_user.doctor_profile if current_user.doctor?
    @prescription.prescribed_at ||= Time.current.to_s

    if @prescription.save
      redirect_to @prescription, notice: 'Prescription was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @prescription.prescription_items.build if @prescription.prescription_items.empty?
  end

  def update
    if @prescription.update(prescription_params)
      redirect_to @prescription, notice: 'Prescription was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @prescription.destroy
    redirect_to prescriptions_path, notice: 'Prescription was successfully destroyed.'
  end

  private

  def prescription_params
    params.require(:prescription).permit(
      :patient_id, :doctor_profile_id, :medical_record_id, :prescribed_at,
      prescription_items_attributes: [:id, :medicine_id, :dosage, :frequency, :duration, :_destroy]
    )
  end
end
