# spec/system/appointments_spec.rb
require 'rails_helper'

RSpec.describe "Appointment Booking Workflow", type: :system, js: true do
  let(:patient_user)     { create(:user, role: "patient") }
  let!(:patient)         { create(:patient, user: patient_user) }
  let!(:patient_profile) { create(:patient_profile, patient: patient, first_name: "John", last_name: "Doe") }
  let(:doctor_user)      { create(:user, :doctor) }
  let!(:doctor)          { create(:doctor_profile, user: doctor_user, name: "Sarah Adams") }

  before do
    sign_in patient_user
  end

  it "allows a patient to pick a specialist, schedule a slot, and view the receipt" do
    visit new_appointment_path

    # 1. Verify patient booking badge
    expect(page).to have_content(/Booking For Patient/i)
    expect(page).to have_content("John Doe")

    # 2. Select consulting specialist from dropdown
    select "Dr. Sarah Adams — #{doctor.department&.name || 'General Medicine'}", from: "Consulting Specialist *"

    # 3. Fill scheduled date and reason
    fill_in "Date & Time *", with: 2.days.from_now.strftime("%Y-%m-%dT10:00")
    fill_in "Symptoms / Visit Reason", with: "Experiencing mild throat irritation and fever"

    # 4. Submit form
    click_button "Confirm & Book Appointment"

    # 5. Verify redirection and confirmation screen (matches "Appointment was successfully created.")
    expect(page).to have_content("Appointment was successfully created")
    expect(page).to have_content(/Consultation Itinerary/i)
    expect(page).to have_content("Sarah Adams")
    expect(page).to have_content("John Doe")
  end
end