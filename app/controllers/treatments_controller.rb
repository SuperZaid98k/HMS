class TreatmentsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def create
    if @treatment.save
      redirect_to @treatment, notice: 'treatment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  # UPDATE (Save to Database)
  def update
    if @treatment.update(treatment_params)
      redirect_to @treatment, notice: 'treatment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE
  def destroy
    @treatment.destroy
    redirect_to treatments_path, notice: 'treatment was successfully destroyed.'
  end

  private

  # Strong parameters for security (adjust fields to match your database)
  def treatment_params
    params.require(:treatment).permit(:name, :description )
  end
end
