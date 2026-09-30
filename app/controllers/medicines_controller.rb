class MedicinesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def create
    if @medicine.save
      redirect_to @medicine, notice: 'medicine was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  # UPDATE (Save to Database)
  def update
    if @medicine.update(medicine_params)
      redirect_to @medicine, notice: 'medicine was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE
  def destroy
    @medicine.destroy
    redirect_to medicines_path, notice: 'medicine was successfully destroyed.'
  end

  private

  # Strong parameters for security (adjust fields to match your database)
  def medicine_params
    params.require(:medicine).permit(:name, :description )
  end
end
