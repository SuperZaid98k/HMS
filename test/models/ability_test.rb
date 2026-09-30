require "test_helper"

class AbilityTest < ActiveSupport::TestCase
  test "admin can manage all resources" do
    admin = User.new(role: "admin")
    ability = Ability.new(admin)

    assert ability.can?(:manage, :all)
    assert ability.can?(:manage, User)
    assert ability.can?(:manage, Hospital)
    assert ability.can?(:manage, Patient)
    assert ability.can?(:manage, Invoice)
    assert ability.can?(:manage, Prescription)
  end

  test "doctor permissions" do
    doctor_user = User.new(role: "doctor")
    doc_profile = DoctorProfile.new(id: 42, user: doctor_user)
    doctor_user.doctor_profile = doc_profile
    ability = Ability.new(doctor_user)

    # Doctor can read infrastructure and directory
    assert ability.can?(:read, Hospital)
    assert ability.can?(:read, Department)
    assert ability.can?(:read, Ward)
    assert ability.can?(:read, Room)
    assert ability.can?(:read, Bed)
    assert ability.can?(:read, Specialization)
    assert ability.can?(:read, DoctorProfile)
    assert ability.can?(:read, Patient)
    assert ability.can?(:update, doc_profile)

    # Doctor can manage own clinical records
    own_rx = Prescription.new(doctor_profile_id: 42)
    other_rx = Prescription.new(doctor_profile_id: 99)
    assert ability.can?(:create, Prescription)
    assert ability.can?(:read, own_rx)
    assert ability.can?(:update, own_rx)
    assert ability.can?(:destroy, own_rx)
    assert ability.cannot?(:update, other_rx)

    # Doctor cannot manage users or invoices
    assert ability.cannot?(:manage, User)
    assert ability.cannot?(:manage, Invoice)
    assert ability.cannot?(:create, Invoice)
  end

  test "staff permissions" do
    staff_user = User.new(role: "staff")
    staff_profile = StaffProfile.new(id: 10, user: staff_user)
    staff_user.staff_profile = staff_profile
    ability = Ability.new(staff_user)

    # Staff operations
    assert ability.can?(:manage, Admission)
    assert ability.can?(:manage, Invoice)
    assert ability.can?(:manage, InsurancePolicy)

    # Staff patient registration & appointments
    assert ability.can?(:create, Patient)
    assert ability.can?(:read, Patient)
    assert ability.can?(:update, Patient)
    assert ability.can?(:create, Appointment)
    assert ability.can?(:read, Appointment)
    assert ability.can?(:update, Appointment)

    # Staff infrastructure & profile
    assert ability.can?(:read, Hospital)
    assert ability.can?(:read, Ward)
    assert ability.can?(:read, Bed)
    assert ability.can?(:update, Bed)
    assert ability.can?(:read, StaffProfile)
    assert ability.can?(:update, staff_profile)

    # Staff cannot create prescriptions or manage users
    assert ability.cannot?(:create, Prescription)
    assert ability.cannot?(:create, MedicalRecord)
    assert ability.cannot?(:manage, User)
  end

  test "patient permissions" do
    patient_user = User.new(role: "patient")
    patient = Patient.new(id: 7, user: patient_user)
    patient_user.patient = patient
    ability = Ability.new(patient_user)

    # Patient directory access
    assert ability.can?(:read, Hospital)
    assert ability.can?(:read, Department)
    assert ability.can?(:read, DoctorProfile)

    # Patient can access own records
    own_appt = Appointment.new(patient_id: 7)
    other_appt = Appointment.new(patient_id: 99)
    assert ability.can?(:create, Appointment)
    assert ability.can?(:read, own_appt)
    assert ability.cannot?(:read, other_appt)

    own_rx = Prescription.new(patient_id: 7)
    other_rx = Prescription.new(patient_id: 99)
    assert ability.can?(:read, own_rx)
    assert ability.cannot?(:read, other_rx)

    own_invoice = Invoice.new(patient_id: 7)
    other_invoice = Invoice.new(patient_id: 99)
    assert ability.can?(:read, own_invoice)
    assert ability.cannot?(:read, other_invoice)

    # Patient cannot create clinical records or manage operations
    assert ability.cannot?(:create, MedicalRecord)
    assert ability.cannot?(:create, Prescription)
    assert ability.cannot?(:create, Invoice)
    assert ability.cannot?(:manage, User)
  end

  test "guest permissions" do
    ability = Ability.new(nil)
    assert ability.cannot?(:manage, :all)
    assert ability.cannot?(:manage, User)
    assert ability.cannot?(:create, Appointment)
    assert ability.cannot?(:create, Patient)
  end
end
