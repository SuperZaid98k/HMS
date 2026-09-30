class DoctorProfilesController < ApplicationController
  load_and_authorize_resource

  def index
    @doctor_profiles = @doctor_profiles.includes(:department, :user, :specializations)
  end

  def show
  end

  def new
  end

  def create
    if @doctor_profile.save
      redirect_to @doctor_profile, notice: 'Doctor profile was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @doctor_profile.update(doctor_profile_params)
      redirect_to @doctor_profile, notice: 'Doctor profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @doctor_profile.destroy
    redirect_to doctor_profiles_path, notice: 'Doctor profile was successfully destroyed.'
  end

  private

  def doctor_profile_params
    params.require(:doctor_profile).permit(:user_id, :department_id, :name, :license_number, :experience_years, :mentor_id, specialization_ids: [])
  end
end
