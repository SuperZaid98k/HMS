class LabTestResultsController < ApplicationController
  before_action :authenticate_user!
  load_resource :lab_test
  load_and_authorize_resource :lab_test_result, through: :lab_test, singleton: true

  def new
  end

  def create
    @lab_test_result.tested_at ||= Time.current.to_s

    if @lab_test_result.save
      @lab_test.update(status: "done")
      redirect_to @lab_test, notice: 'Lab test result saved successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @lab_test_result.update(lab_test_result_params)
      redirect_to @lab_test, notice: 'Lab test result updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def lab_test_result_params
    params.require(:lab_test_result).permit(:result, :reference_range, :unit, :tested_at)
  end
end
