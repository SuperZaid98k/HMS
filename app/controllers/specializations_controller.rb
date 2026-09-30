class SpecializationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :index]
  load_and_authorize_resource

  def index
  end

  def show
    @doctor_profiles = @specialization.doctor_profiles.includes(:user, :department, :specializations).load
  end

  def new
  end

  def create
    if @specialization.save
      redirect_to @specialization, notice: 'specialization was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  # UPDATE (Save to Database)
  def update
    if @specialization.update(specialization_params)
      redirect_to @specialization, notice: 'specialization was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE
  def destroy
    @specialization.destroy
    redirect_to specializations_path, notice: 'specialization was successfully destroyed.'
  end

  private

  # Strong parameters for security (adjust fields to match your database)
  def specialization_params
    params.require(:specialization).permit(:name, :description )
  end
end
