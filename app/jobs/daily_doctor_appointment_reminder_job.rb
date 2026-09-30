class DailyDoctorAppointmentReminderJob < ApplicationJob
  queue_as :default

  def perform
    today_start = Time.current.beginning_of_day
    today_end   = Time.current.end_of_day

    # 1. Fetch all doctors who have appointments scheduled today
    doctors_with_appointments = DoctorProfile.joins(:appointments)
                                             .where(appointments: { scheduled_at: today_start..today_end })
                                             .where.not(appointments: { status: "cancelled" })
                                             .includes(:user)
                                             .distinct

    # 2. Iterate and send daily agenda to each doctor
    doctors_with_appointments.find_each do |doctor|
      todays_appointments = doctor.appointments
                                  .where(scheduled_at: today_start..today_end)
                                  .where.not(status: "cancelled")
                                  .includes(patient: :patient_profile)
                                  .order(:scheduled_at)

      AppointmentMailer.doctor_daily_agenda(doctor, todays_appointments).deliver_later
    end
  end
end