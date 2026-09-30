# app/controllers/appointments_controller.rb
class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  
  # CanCanCan replaces manual finders and authorization checks
  load_and_authorize_resource

  def index
    # @appointments is already scoped: Appointment.accessible_by(current_ability)
    # Eager load associations to avoid N+1 queries
    @appointments = @appointments.includes(
      :doctor_profile, 
      patient: :patient_profile
    )
  end

  def show
    # @appointment is already loaded and authorized
  end

  def new
    if current_user.patient?
      # Ensure patient record exists
      patient = current_user.patient || current_user.create_patient!(
        patient_number: "PAT-#{SecureRandom.random_number(10_000..99_999)}"
      )

      # If patient profile is missing or unpersisted
      if patient.patient_profile.nil? || patient.patient_profile.new_record?
        redirect_to new_patient_profile_path, 
                    alert: "Please complete your patient profile details before booking an appointment."
        return
      end

      # Pre-assign patient if profile exists
      @appointment.patient = patient
    end

    # Pre-select doctor if passed from the specialization page
    if params[:doctor_profile_id].present?
      @appointment.doctor_profile_id = params[:doctor_profile_id]
    end
  end

  def create
    # Pre-assign patient_id if booked by a patient
    @appointment.patient = current_user.patient if current_user.patient?

    if @appointment.save

      AppointmentMailer.booking_confirmation(@appointment).deliver_later
      AppointmentMailer.doctor_new_appointment_notification(@appointment).deliver_later

      redirect_to @appointment, notice: "Appointment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @appointment is already loaded and verified
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to @appointment, notice: "Appointment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @appointment.destroy
    redirect_to appointments_path, notice: "Appointment was successfully cancelled."
  end

  private

  def appointment_params
    permitted = [:scheduled_at, :reason]
    # Restrict status, patient_id, and doctor reassignment
    if current_user.admin? || current_user.doctor? || current_user.staff?
      permitted += [:status, :patient_id, :doctor_profile_id, ]
    elsif current_user.patient?
      permitted += [:doctor_profile_id] # Patients can pick the doctor
    end
    params.require(:appointment).permit(permitted)
  end
end