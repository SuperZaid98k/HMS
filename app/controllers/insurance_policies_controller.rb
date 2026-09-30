class InsurancePoliciesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @insurance_policies = @insurance_policies.includes(:patient)
  end

  def show
  end

  def new
    @insurance_policy.patient_id = params[:patient_id] if params[:patient_id].present?
  end

  def create
    if @insurance_policy.save
      redirect_to @insurance_policy.patient, notice: 'Insurance policy was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @insurance_policy.update(insurance_policy_params)
      redirect_to @insurance_policy.patient, notice: 'Insurance policy was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    patient = @insurance_policy.patient
    @insurance_policy.destroy
    redirect_to patient || insurance_policies_path, notice: 'Insurance policy deleted.'
  end

  private

  def insurance_policy_params
    params.require(:insurance_policy).permit(:patient_id, :provider_name, :policy_number, :coverage_amount, :valid_from, :valid_until)
  end
end
