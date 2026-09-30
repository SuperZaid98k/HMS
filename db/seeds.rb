# db/seeds_more_hospitals.rb
#
# Adds 6 more hospitals, each with a full set of associated data
# (departments, doctors, staff, patients, wards/rooms/beds, admissions,
# appointments, medical records, prescriptions, lab tests, insurance,
# invoices/payments, documents) plus a handful of contact messages.
#
# This is ADDITIVE — it does not delete any existing data.
#
# How to run it:
#   bin/rails runner db/seeds_more_hospitals.rb
#
# ...or add this line to the bottom of db/seeds.rb so `rails db:seed` picks it up too:
#   load Rails.root.join("db", "seeds_more_hospitals.rb")

puts "== Adding 6 more hospitals =="

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

FIRST_NAMES = %w[Aarav Vivaan Aditya Vihaan Arjun Sai Reyansh Ayaan Krishna Ishaan
                 Ananya Diya Saanvi Aadhya Kiara Myra Anika Navya Riya Sara
                 Rohan Karan Priya Neha Amit Rahul Sneha Pooja Vikram Meera
                 Tanvi Aryan Ira Yash Simran Devansh Kavya Nikhil Zara Om]
LAST_NAMES  = %w[Sharma Verma Gupta Patel Reddy Iyer Nair Singh Rao Mehta
                  Kulkarni Joshi Deshmukh Chatterjee Bose Malhotra Kapoor Chauhan Pillai Menon]

def random_name
  "#{FIRST_NAMES.sample} #{LAST_NAMES.sample}"
end

def random_phone
  "9#{rand(100_000_000..999_999_999)}"
end

def random_email(name, domain)
  "#{name.downcase.gsub(/[^a-z]+/, '.')}.#{SecureRandom.hex(3)}@#{domain}"
end

def random_date_string(range_days_ago:, range_days_future: 0)
  (Date.today - rand(range_days_ago)..Date.today + range_days_future).to_a.sample.to_s
end

def random_datetime(days_ago: 90)
  Time.now - rand(0..days_ago).days - rand(0..23).hours
end

# ---------------------------------------------------------------------------
# Global reference data (reuse if it already exists, otherwise create it)
# ---------------------------------------------------------------------------

specializations = Specialization.all.to_a
if specializations.empty?
  specializations = ["Interventional Cardiology", "Pediatric Neurology", "Joint Replacement",
                      "Cosmetic Dermatology", "Diabetes Management", "Sports Medicine",
                      "General Surgery", "Internal Medicine"].map do |name|
    Specialization.create!(name: name, description: "Specialization in #{name.downcase}")
  end
end

treatments = Treatment.all.to_a
if treatments.empty?
  treatments = ["Physiotherapy", "Chemotherapy", "Dialysis", "Wound Dressing",
                "IV Fluid Therapy", "Post-Op Care"].map do |name|
    Treatment.create!(name: name, description: "Standard protocol for #{name.downcase}")
  end
end

medicines = Medicine.all.to_a
if medicines.empty?
  medicines = [
    { name: "Paracetamol 500mg", manufacturer: "Cipla" },
    { name: "Amoxicillin 250mg", manufacturer: "Sun Pharma" },
    { name: "Metformin 500mg", manufacturer: "Dr. Reddy's" },
    { name: "Amlodipine 5mg", manufacturer: "Lupin" },
    { name: "Cetirizine 10mg", manufacturer: "Zydus" },
    { name: "Ibuprofen 400mg", manufacturer: "Cipla" },
    { name: "Omeprazole 20mg", manufacturer: "Sun Pharma" },
    { name: "Azithromycin 500mg", manufacturer: "Alkem" }
  ].map { |m| Medicine.create!(name: m[:name], manufacturer: m[:manufacturer], description: "Used to treat related conditions as prescribed.") }
end

blood_groups = %w[A+ A- B+ B- O+ O- AB+ AB-]

# Starting numbers so we never collide with any existing patient_number / employee_number
patient_seq = (Patient.maximum(:id) || 0) + 1000
staff_seq   = (StaffProfile.maximum(:id) || 0) + 1000
invoice_seq = rand(700_000..799_999)

# ---------------------------------------------------------------------------
# The 6 new hospitals
# ---------------------------------------------------------------------------

HOSPITAL_DEFS = [
  { name: "Lakeview Medical Center",       city: "Nagpur" },
  { name: "Horizon Heart Institute",       city: "Pune" },
  { name: "Green Valley Hospital",         city: "Nashik" },
  { name: "Riverside Children's Hospital", city: "Mumbai" },
  { name: "Silver Oak Multispeciality",    city: "Aurangabad" },
  { name: "Northgate Trauma Center",       city: "Nagpur" }
]

DEPARTMENT_NAMES = ["Cardiology", "Neurology", "Orthopedics", "Pediatrics",
                     "General Medicine", "Dermatology", "Oncology", "ENT"]

HOSPITAL_DEFS.each do |hdef|
  puts "-- #{hdef[:name]} --"

  hospital = Hospital.create!(
    name: hdef[:name],
    address: "#{rand(1..300)} #{['MG Road', 'Station Road', 'Ring Road', 'Civil Lines'].sample}, #{hdef[:city]}",
    phone: random_phone,
    email: random_email(hdef[:name], "hospitals.example"),
    registration_number: "REG-#{hdef[:city][0, 3].upcase}-#{rand(1000..9999)}"
  )

  # -- Departments -----------------------------------------------------------
  departments = DEPARTMENT_NAMES.sample(4).map do |dept_name|
    Department.create!(
      name: dept_name,
      description: "#{dept_name} department at #{hospital.name}",
      hospital_id: hospital.id
    )
  end

  # -- Doctors (users with role "doctor" + doctor_profiles) ------------------
  doctor_profiles = 6.times.map do
    name = random_name
    user = User.create!(
      name: "Dr. #{name}",
      email: random_email(name, "carewell.example"),
      password: "password123",
      role: "doctor"
    )
    DoctorProfile.create!(
      user_id: user.id,
      name: user.name,
      department_id: departments.sample.id,
      license_number: "LIC-#{rand(100_000..999_999)}",
      experience_years: rand(1..25).to_s
    )
  end

  senior_doctors = doctor_profiles.first(2)
  doctor_profiles.drop(2).each do |dp|
    dp.update!(mentor_id: senior_doctors.sample.id) if rand < 0.6
  end

  doctor_profiles.each do |dp|
    specializations.sample(rand(1..3)).each do |spec|
      ActiveRecord::Base.connection.execute(
        "INSERT INTO doctor_profiles_specializations (doctor_profile_id, specialization_id, created_at, updated_at) " \
        "VALUES (#{dp.id}, #{spec.id}, '#{Time.now}', '#{Time.now}')"
      )
    end
  end

  # -- Staff (users with role "staff" + staff_profiles) ----------------------
  staff_profiles = 4.times.map do
    name = random_name
    user = User.create!(
      name: name,
      email: random_email(name, "carewell.example"),
      password: "password123",
      role: "staff"
    )
    staff_seq += 1
    StaffProfile.create!(
      user_id: user.id,
      department_id: departments.sample.id,
      employee_number: "EMP-#{staff_seq}",
      joining_date: random_date_string(range_days_ago: 1200),
      phone: random_phone
    )
  end
  staff_users = User.where(id: staff_profiles.map(&:user_id))

  # -- Patients (users with role "patient" + patients + patient_profiles) ----
  patients = 12.times.map do
    first = FIRST_NAMES.sample
    last = LAST_NAMES.sample
    full_name = "#{first} #{last}"
    user = User.create!(
      name: full_name,
      email: random_email(full_name, "patients.example"),
      password: "password123",
      role: "patient"
    )
    patient_seq += 1
    patient = Patient.create!(user_id: user.id, patient_number: "PAT-#{patient_seq}")
    PatientProfile.create!(
      patient_id: patient.id,
      first_name: first,
      last_name: last,
      date_of_birth: (Date.today - rand(1..85).years - rand(0..365).days).to_s,
      gender: %w[male female other].sample,
      phone: random_phone,
      address: "#{rand(1..500)} #{['Park Street', 'Civil Lines', 'MG Road', 'Ring Road'].sample}, #{hdef[:city]}",
      blood_group: blood_groups.sample
    )
    patient
  end

  # -- Wards / rooms / beds ---------------------------------------------------
  wards = %w[General ICU Maternity].map do |ward_type|
    Ward.create!(hospital_id: hospital.id, name: "#{ward_type} Ward", ward_type: ward_type)
  end

  rooms = wards.flat_map do |ward|
    3.times.map do |i|
      Room.create!(
        ward_id: ward.id,
        room_number: "#{ward.id}-R#{i + 1}",
        room_type: %w[general semi-private private].sample
      )
    end
  end

  beds = rooms.flat_map do |room|
    2.times.map do |i|
      Bed.create!(room_id: room.id, bed_number: "#{room.room_number}-B#{i + 1}", status: %w[occupied free].sample)
    end
  end

  # -- Admissions --------------------------------------------------------------
  6.times do
    status = %w[admitted discharged].sample
    Admission.create!(
      patient_id: patients.sample.id,
      bed_id: beds.sample.id,
      admitted_at: random_date_string(range_days_ago: 45),
      discharged_at: status == "discharged" ? random_date_string(range_days_ago: 10) : nil,
      status: status
    )
  end

  # -- Appointments + notes -----------------------------------------------------
  appointments = 14.times.map do
    Appointment.create!(
      patient_id: patients.sample.id,
      doctor_profile_id: doctor_profiles.sample.id,
      scheduled_at: random_datetime(days_ago: 75),
      reason: ["Routine checkup", "Follow-up visit", "Fever and cold", "Chest pain",
               "Annual physical", "Skin rash", "Joint pain", "Headache"].sample,
      status: %w[scheduled completed cancelled].sample
    )
  end

  8.times do
    AppointmentNote.create!(
      appointment_id: appointments.sample.id,
      user_id: (doctor_profiles.map(&:user_id) + staff_users.map(&:id)).sample,
      content: ["Patient responded well to treatment.", "Follow-up required in 2 weeks.",
                "Advised rest and hydration.", "Referred to specialist.",
                "Vitals stable at time of visit."].sample
    )
  end

  # -- Medical records + entries -------------------------------------------------
  medical_records = 10.times.map do
    appointment = appointments.sample
    MedicalRecord.create!(
      patient_id: appointment.patient_id,
      doctor_profile_id: appointment.doctor_profile_id,
      appointment_id: appointment.id,
      diagnosis: ["Common cold", "Hypertension", "Type 2 Diabetes", "Migraine",
                  "Fracture", "Allergic reaction", "Gastritis", "Bronchitis"].sample,
      description: "Patient examined and diagnosis recorded after consultation."
    )
  end

  8.times do
    record = medical_records.sample
    MedicalEntry.create!(patient_id: record.patient_id, entryable_type: "MedicalRecord", entryable_id: record.id)
  end

  # -- Treatment assignments -------------------------------------------------------
  6.times do
    started = random_date_string(range_days_ago: 40)
    completed = rand < 0.5
    TreatmentAssignment.create!(
      medical_record_id: medical_records.sample.id,
      treatment_id: treatments.sample.id,
      started_at: started,
      completed_at: completed ? random_date_string(range_days_ago: 10) : nil,
      notes: completed ? "Treatment completed successfully." : "Treatment in progress."
    )
  end

  # -- Prescriptions + items ------------------------------------------------------
  prescriptions = medical_records.sample(8).map do |record|
    Prescription.create!(
      patient_id: record.patient_id,
      doctor_profile_id: record.doctor_profile_id,
      medical_record_id: record.id,
      prescribed_at: random_date_string(range_days_ago: 25)
    )
  end

  prescriptions.each do |prescription|
    rand(1..3).times do
      PrescriptionItem.create!(
        prescription_id: prescription.id,
        medicine_id: medicines.sample.id,
        dosage: ["1 tablet", "2 tablets", "5ml", "10ml"].sample,
        frequency: ["once daily", "twice daily", "thrice daily", "as needed"].sample,
        duration: ["3 days", "5 days", "7 days", "14 days"].sample
      )
    end
  end

  # -- Lab tests + results ---------------------------------------------------------
  lab_tests = 10.times.map do
    LabTest.create!(
      patient_id: patients.sample.id,
      doctor_profile_id: doctor_profiles.sample.id,
      test_name: ["Complete Blood Count", "Blood Sugar (Fasting)", "Lipid Profile",
                  "Thyroid Profile", "COVID-19 RT-PCR", "Liver Function Test",
                  "Urine Routine", "X-Ray Chest"].sample,
      status: %w[pending done].sample,
      requested_at: random_date_string(range_days_ago: 30)
    )
  end

  lab_tests.select { |lt| lt.status == "done" }.each do |lab_test|
    LabTestResult.create!(
      lab_test_id: lab_test.id,
      result: %w[positive negative].sample,
      unit: ["mg/dL", "%", "cells/mcL", "IU/L"].sample,
      reference_range: ["70-100", "0-5", "4.5-11.0", "13-15"].sample,
      tested_at: random_date_string(range_days_ago: 15)
    )
  end

  # -- Insurance policies -----------------------------------------------------------
  6.times do
    valid_from = Date.today - rand(30..600)
    InsurancePolicy.create!(
      patient_id: patients.sample.id,
      provider_name: ["Star Health", "ICICI Lombard", "HDFC Ergo", "New India Assurance", "Bajaj Allianz"].sample,
      policy_number: "POL-#{rand(100_000..999_999)}",
      coverage_amount: [100_000, 200_000, 500_000, 1_000_000].sample.to_s,
      valid_from: valid_from.to_s,
      valid_until: (valid_from + 365).to_s
    )
  end

  # -- Invoices + items + payments ---------------------------------------------------
  appointments.sample(10).each do |appointment|
    status = %w[paid due].sample
    invoice_seq += 1
    invoice = Invoice.create!(
      patient_id: appointment.patient_id,
      appointment_id: appointment.id,
      invoice_number: "INV-#{invoice_seq}",
      issued_at: random_date_string(range_days_ago: 45),
      status: status,
      total_amount: nil
    )

    items = rand(1..4).times.map do
      description = ["Consultation Fee", "Lab Test Fee", "Room Charges", "Medicine Charges",
                      "Procedure Fee", "Nursing Charges"].sample
      quantity = rand(1..3)
      unit_price = [200, 500, 800, 1200, 1500, 2500].sample
      InvoiceItem.create!(invoice_id: invoice.id, description: description, quantity: quantity.to_s, amount: (quantity * unit_price).to_s)
    end

    total = items.sum { |i| i.amount.to_i }
    invoice.update!(total_amount: total.to_s)

    if status == "paid"
      Payment.create!(
        invoice_id: invoice.id,
        amount: total.to_s,
        payment_method: %w[cash upi card].sample,
        paid_at: random_date_string(range_days_ago: 20),
        status: "success"
      )
    end
  end

  # -- Documents --------------------------------------------------------------------
  6.times do
    if rand < 0.5
      patient = patients.sample
      Document.create!(
        documentable_type: "Patient",
        documentable_id: patient.id,
        name: ["ID Proof", "Insurance Card", "Previous Medical History"].sample,
        file_url: "https://storage.carewell.example/documents/#{SecureRandom.hex(8)}.pdf",
        uploaded_at: random_date_string(range_days_ago: 90)
      )
    else
      record = medical_records.sample
      Document.create!(
        documentable_type: "MedicalRecord",
        documentable_id: record.id,
        name: ["Lab Report", "Discharge Summary", "X-Ray Scan"].sample,
        file_url: "https://storage.carewell.example/documents/#{SecureRandom.hex(8)}.pdf",
        uploaded_at: random_date_string(range_days_ago: 45)
      )
    end
  end

  puts "   departments=#{departments.size} doctors=#{doctor_profiles.size} staff=#{staff_profiles.size} " \
       "patients=#{patients.size} beds=#{beds.size} appointments=#{appointments.size} " \
       "medical_records=#{medical_records.size} lab_tests=#{lab_tests.size}"
end

# ---------------------------------------------------------------------------
# A few contact messages (not hospital-scoped)
# ---------------------------------------------------------------------------

puts "-- Contact messages --"

10.times do
  name = random_name
  ContactMessage.create!(
    name: name,
    email: random_email(name, "example.com"),
    contact_no: random_phone,
    message: ["I'd like to book an appointment with a cardiologist.",
              "What are your visiting hours for the ICU?",
              "Can you share the cost estimate for a knee replacement?",
              "I need a copy of my discharge summary.",
              "Do you accept Star Health insurance?"].sample,
    status: %w[new read resolved].sample
  )
end

puts "== Done adding 6 hospitals =="
puts "Hospitals: #{Hospital.count}"
puts "Departments: #{Department.count}"
puts "Users: #{User.count} (by role: #{User.group(:role).count})"
puts "Doctor profiles: #{DoctorProfile.count}"
puts "Staff profiles: #{StaffProfile.count}"
puts "Patients: #{Patient.count}"
puts "Wards: #{Ward.count}, Rooms: #{Room.count}, Beds: #{Bed.count}"
puts "Admissions: #{Admission.count}"
puts "Appointments: #{Appointment.count}"
puts "Medical records: #{MedicalRecord.count}"
puts "Prescriptions: #{Prescription.count}, Prescription items: #{PrescriptionItem.count}"
puts "Lab tests: #{LabTest.count}, Lab test results: #{LabTestResult.count}"
puts "Insurance policies: #{InsurancePolicy.count}"
puts "Invoices: #{Invoice.count}, Invoice items: #{InvoiceItem.count}, Payments: #{Payment.count}"
puts "Documents: #{Document.count}"
puts "Contact messages: #{ContactMessage.count}"