class WardsController < ApplicationController
  load_and_authorize_resource :hospital, only: [:new, :create]
  load_and_authorize_resource :ward, through: :hospital, only: [:new, :create]
  load_and_authorize_resource :ward, only: [:show, :edit, :update, :destroy]

  def show
    @hospital = @ward.hospital
  end

  def new
  end

  def create
    if @ward.save
      redirect_to ward_path(@ward), notice: "Ward was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @hospital = @ward.hospital
  end

  def update
    if @ward.update(ward_params)
      redirect_to ward_path(@ward), notice: "Ward was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    hospital = @ward.hospital
    @ward.destroy
    redirect_to hospital_path(hospital), notice: "Ward was successfully deleted."
  end

  private

  def ward_params
    params.require(:ward).permit(:name, :ward_type)
  end
end