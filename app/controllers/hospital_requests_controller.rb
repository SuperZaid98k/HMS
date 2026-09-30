class HospitalRequestsController < ApplicationController
  # Allow external hospital representatives to apply without logging in
  skip_before_action :authenticate_user!, only: [:new, :create, :show]

  def new
    @hospital_request = HospitalRequest.new
  end

  def create
    @hospital_request = HospitalRequest.new(hospital_request_params)
    @hospital_request.status = "pending"

    if @hospital_request.save
      HospitalRequestMailer.submission_confirmation(@hospital_request).deliver_later
      redirect_to hospital_request_path(@hospital_request), 
                  notice: "Thank you! Your hospital onboarding application has been submitted successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @hospital_request = HospitalRequest.find(params[:id])
  end

  private

  def hospital_request_params
    params.require(:hospital_request).permit(
      :hospital_name,
      :contact_person_name,
      :email,
      :phone,
      :city,
      :state,
      :address,
      :total_beds,
      :specialties,
      :notes
    )
  end
end