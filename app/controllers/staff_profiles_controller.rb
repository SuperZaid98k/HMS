class StaffProfilesController < ApplicationController
  load_and_authorize_resource

  def index
    @staff_profiles = @staff_profiles.includes(:department, :user)
  end

  def show
  end

  def new
  end

  def create
    if @staff_profile.save
      redirect_to @staff_profile, notice: 'Staff profile was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @staff_profile.update(staff_profile_params)
      redirect_to @staff_profile, notice: 'Staff profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @staff_profile.destroy
    redirect_to staff_profiles_path, notice: 'Staff profile was successfully destroyed.'
  end

  private

  def staff_profile_params
    params.require(:staff_profile).permit(:user_id, :department_id, :employee_number, :joining_date, :phone)
  end
end
