class DepartmentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :hospital
  load_and_authorize_resource :department, through: :hospital

  def show
  end

  def new
  end

  def create
    if @department.save
      redirect_to hospital_path(@hospital), notice: "Department was successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @department.update(department_params)
      redirect_to hospital_path(@hospital), notice: "Department was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @department.destroy
    redirect_to hospital_path(@hospital), notice: "Department was removed."
  end

  private

  # Strong parameters for security (adjust fields to match your database)
  def department_params
    params.require(:department).permit( :hospital_id, :name, :description )
  end
end
