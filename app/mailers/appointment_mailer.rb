# app/mailers/appointment_mailer.rb
class AppointmentMailer < ApplicationMailer
  default from: "mz7218790990@gmail.com"

  def booking_confirmation(appointment)
    @appointment = appointment
    @patient = appointment.patient
    @doctor = appointment.doctor_profile

    # Retrieve patient email from associated User account
    recipient_email = @patient.user&.email

    return unless recipient_email.present?

    mail(
      to: recipient_email,
      subject: "Appointment Confirmation - ##{@appointment.id} | HMS Healthcare"
    )


  end


  def doctor_new_appointment_notification(appointment)
    @appointment = appointment
    @doctor = appointment.doctor_profile
    @patient = appointment.patient
    @patient_profile = @patient&.patient_profile

    # Extract doctor's registered email
    doctor_email = @doctor&.user&.email

    return unless doctor_email.present?

    patient_name = @patient_profile ? "#{@patient_profile.first_name} #{@patient_profile.last_name}" : "Patient ##{@patient.id}"

    mail(
      to: doctor_email,
      subject: "New Consultation Booked: #{patient_name} - ##{@appointment.id} | HMS OPD"
    )
  end

  def doctor_daily_agenda(doctor, appointments)
    @doctor = doctor
    @appointments = appointments
    doctor_email = @doctor.user&.email

    return if doctor_email.blank? || @appointments.empty?

    mail(
      to: doctor_email,
      subject: "Daily OPD Schedule: #{@appointments.size} Appointment(s) Today - #{Date.current.strftime('%b %d, %Y')}"
    )
  end
end