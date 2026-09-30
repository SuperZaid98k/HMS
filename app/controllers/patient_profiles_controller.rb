class PatientProfilesController < ApplicationController
  load_and_authorize_resource

  def index
    @patient_profiles = @patient_profiles.includes(:patient)
  end

  def new
    @patient = current_user.patient || current_user.create_patient!(
      patient_number: "PAT-#{SecureRandom.random_number(10_000..99_999)}"
    )
    @patient_profile = @patient.build_patient_profile
  end

  def create
    @patient = current_user.patient || current_user.create_patient!(
      patient_number: "PAT-#{SecureRandom.random_number(10_000..99_999)}"
    )
    @patient_profile = @patient.build_patient_profile(patient_profile_params)

    if @patient_profile.save
      redirect_to new_appointment_path, notice: "Profile completed successfully! Now you can schedule your appointment."
    else
      render :new, status: :unprocessable_entity
    end
  end


  def show
  end

  def edit
  end

  def update
    if @patient_profile.update(patient_profile_params)
      redirect_to @patient_profile.patient, notice: 'Patient profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    patient = @patient_profile.patient
    @patient_profile.destroy
    redirect_to patient, notice: 'Patient profile was successfully destroyed.'
  end

  private

  def patient_profile_params
    params.require(:patient_profile).permit(:first_name, :last_name, :date_of_birth, :gender, :phone, :blood_group, :address)
  end
end
