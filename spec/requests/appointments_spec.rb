# spec/requests/appointments_spec.rb
require 'rails_helper'

RSpec.describe "AppointmentsController", type: :request do
  let(:patient_user) { create(:user, role: "patient") }
  let!(:patient)     { create(:patient, user: patient_user) }
  let(:doctor_user)  { create(:user, :doctor) }
  let(:doctor)       { create(:doctor_profile, user: doctor_user) }

  describe "POST /appointments" do
    context "when authenticated as a patient" do
      before { sign_in patient_user }

      it "creates an appointment and queues confirmation emails via ActiveJob" do
        appointment_params = {
          appointment: {
            doctor_profile_id: doctor.id,
            scheduled_at: 1.day.from_now.change(hour: 10, min: 0),
            reason: "Routine clinical follow-up"
          }
        }

        expect {
          post appointments_path, params: appointment_params
        }.to change(Appointment, :count).by(1)
         .and have_enqueued_job(ActionMailer::MailDeliveryJob).at_least(1).times

        created_appointment = Appointment.last
        expect(created_appointment.patient).to eq(patient)
        expect(response).to redirect_to(appointment_path(created_appointment))
      end
    end

    context "when unauthenticated (guest)" do
      it "denies access and redirects to sign in" do
        post appointments_path, params: { appointment: { doctor_profile_id: doctor.id } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end