class PatientsController < ApplicationController
  load_and_authorize_resource

  def index
    @patients = @patients.includes(:patient_profile)
  end

  def show
  end

  def new
    @patient.build_patient_profile
  end

  def create
    if @patient.save
      redirect_to @patient, notice: 'Patient was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @patient.build_patient_profile if @patient.patient_profile.nil?
  end

  def update
    if @patient.update(patient_params)
      redirect_to @patient, notice: 'Patient was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy
    redirect_to patients_path, notice: 'Patient was successfully destroyed.'
  end

  private

  def patient_params
    params.require(:patient).permit(
      :patient_number,
      patient_profile_attributes: [:id, :first_name, :last_name, :date_of_birth, :gender, :phone, :blood_group, :address]
    )
  end
end
