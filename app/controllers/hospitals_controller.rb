class HospitalsController < ApplicationController
  load_and_authorize_resource
  skip_before_action :authenticate_user!, only: [:show, :index]
  def index
  end

  def show
  end

  def new
  end

  def create
    if @hospital.save
      redirect_to @hospital, notice: 'hospital was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  # UPDATE (Save to Database)
  def update
    if @hospital.update(hospital_params)
      redirect_to @hospital, notice: 'hospital was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE
  def destroy
    @hospital.destroy
    redirect_to hospitals_path, notice: 'hospital was successfully destroyed.'
  end

  private

  # Strong parameters for security (adjust fields to match your database)
  def hospital_params
    params.require(:hospital).permit(:name, :registration_number, :phone, :email, :address )
  end
end
