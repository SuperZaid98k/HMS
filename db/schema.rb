# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_28_071259) do
  create_table "admissions", force: :cascade do |t|
    t.string "admitted_at"
    t.integer "bed_id"
    t.datetime "created_at", null: false
    t.string "discharged_at"
    t.integer "patient_id"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "appointment_notes", force: :cascade do |t|
    t.integer "appointment_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "doctor_profile_id"
    t.integer "patient_id"
    t.string "reason"
    t.datetime "scheduled_at"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "beds", force: :cascade do |t|
    t.string "bed_number"
    t.datetime "created_at", null: false
    t.integer "room_id"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "contact_messages", force: :cascade do |t|
    t.string "contact_no"
    t.datetime "created_at", null: false
    t.string "email"
    t.text "message"
    t.string "name"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "hospital_id"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "doctor_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "department_id"
    t.string "experience_years"
    t.string "license_number"
    t.integer "mentor_id"
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["mentor_id"], name: "index_doctor_profiles_on_mentor_id"
  end

  create_table "doctor_profiles_specializations", id: false, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "doctor_profile_id", null: false
    t.integer "specialization_id", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_profile_id", "specialization_id"], name: "idx_doc_spec_unique", unique: true
    t.index ["doctor_profile_id"], name: "index_doctor_profiles_specializations_on_doctor_profile_id"
    t.index ["specialization_id"], name: "index_doctor_profiles_specializations_on_specialization_id"
  end

  create_table "documents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "documentable_id"
    t.string "documentable_type"
    t.string "file_url"
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "uploaded_at"
    t.index ["documentable_type", "documentable_id"], name: "index_documents_on_documentable"
  end

  create_table "hospital_requests", force: :cascade do |t|
    t.text "address", null: false
    t.string "city", null: false
    t.string "contact_person_name", null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "hospital_name", null: false
    t.text "notes"
    t.string "phone", null: false
    t.text "specialties"
    t.string "state"
    t.string "status", default: "pending", null: false
    t.integer "total_beds"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_hospital_requests_on_email"
    t.index ["status"], name: "index_hospital_requests_on_status"
  end

  create_table "hospitals", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "phone"
    t.string "registration_number"
    t.datetime "updated_at", null: false
  end

  create_table "insurance_policies", force: :cascade do |t|
    t.string "coverage_amount"
    t.datetime "created_at", null: false
    t.integer "patient_id"
    t.string "policy_number"
    t.string "provider_name"
    t.datetime "updated_at", null: false
    t.string "valid_from"
    t.string "valid_until"
  end

  create_table "invoice_items", force: :cascade do |t|
    t.string "amount"
    t.datetime "created_at", null: false
    t.string "description"
    t.integer "invoice_id"
    t.string "quantity"
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "appointment_id"
    t.datetime "created_at", null: false
    t.string "invoice_number"
    t.string "issued_at"
    t.integer "patient_id"
    t.string "status"
    t.string "total_amount"
    t.datetime "updated_at", null: false
  end

  create_table "lab_test_results", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "lab_test_id"
    t.string "reference_range"
    t.string "result"
    t.string "tested_at"
    t.string "unit"
    t.datetime "updated_at", null: false
  end

  create_table "lab_tests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "doctor_profile_id"
    t.integer "patient_id"
    t.string "requested_at"
    t.string "status"
    t.string "test_name"
    t.datetime "updated_at", null: false
  end

  create_table "medical_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "entryable_id"
    t.string "entryable_type"
    t.integer "patient_id"
    t.datetime "updated_at", null: false
  end

  create_table "medical_records", force: :cascade do |t|
    t.integer "appointment_id"
    t.datetime "created_at", null: false
    t.string "description"
    t.string "diagnosis"
    t.integer "doctor_profile_id"
    t.integer "patient_id"
    t.datetime "updated_at", null: false
  end

  create_table "medicines", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "manufacturer"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "patient_profiles", force: :cascade do |t|
    t.string "address"
    t.string "blood_group"
    t.datetime "created_at", null: false
    t.string "date_of_birth"
    t.string "first_name"
    t.string "gender"
    t.string "last_name"
    t.integer "patient_id"
    t.string "phone"
    t.datetime "updated_at", null: false
  end

  create_table "patients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "patient_number"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["patient_number"], name: "index_patients_on_patient_number", unique: true
    t.index ["user_id"], name: "index_patients_on_user_id", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.string "amount"
    t.datetime "created_at", null: false
    t.integer "invoice_id"
    t.string "paid_at"
    t.string "payment_method"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "prescription_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "dosage"
    t.string "duration"
    t.string "frequency"
    t.integer "medicine_id"
    t.integer "prescription_id"
    t.datetime "updated_at", null: false
  end

  create_table "prescriptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "doctor_profile_id"
    t.integer "medical_record_id"
    t.integer "patient_id"
    t.string "prescribed_at"
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "room_number"
    t.string "room_type"
    t.datetime "updated_at", null: false
    t.integer "ward_id"
  end

  create_table "specializations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "staff_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "department_id"
    t.string "employee_number"
    t.string "joining_date"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "treatment_assignments", force: :cascade do |t|
    t.string "completed_at"
    t.datetime "created_at", null: false
    t.integer "medical_record_id"
    t.string "notes"
    t.string "started_at"
    t.integer "treatment_id"
    t.datetime "updated_at", null: false
  end

  create_table "treatments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "patient"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "hospital_id"
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "ward_type"
  end

  add_foreign_key "doctor_profiles", "doctor_profiles", column: "mentor_id"
  add_foreign_key "patients", "users"
end
