# app/models/ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, Hospital
    can :read, Specialization
    can :create, ContactMessage
    can :read, :about_us # or public pages
    # app/models/ability.rb
    can [:create, :new, :read], HospitalRequest

    if user.admin?
      can :manage, :all
      can :manage, ContactMessage

    elsif user.doctor?
      can :read, [Hospital, Department, Ward, Room, Bed, Specialization, DoctorProfile]
      can :manage, Document

      if user.doctor_profile
        doc_id = user.doctor_profile.id

        can [:read, :update], Appointment, doctor_profile_id: doc_id
        can :manage, AppointmentNote, appointment: { doctor_profile_id: doc_id }
        can :create, MedicalRecord
        can [:read, :update], MedicalRecord, doctor_profile_id: doc_id
        can :manage, TreatmentAssignment, medical_record: { doctor_profile_id: doc_id }
        can :read, Treatment
        can :create, Prescription
        can [:read, :update, :destroy], Prescription, doctor_profile_id: doc_id
        can :manage, PrescriptionItem, prescription: { doctor_profile_id: doc_id }
        can :read, Medicine
        can :create, LabTest
        can [:read, :update], LabTest, doctor_profile_id: doc_id
        can :manage, LabTestResult, lab_test: { doctor_profile_id: doc_id }
        can :read, Admission
        can :read, Patient
        can :read, PatientProfile
        can :update, DoctorProfile, id: doc_id
      end

    elsif user.staff?
      can :manage, Admission
      can [:read, :update], Bed
      can :manage, Invoice
      can :manage, InvoiceItem
      can :manage, Payment
      can :manage, InsurancePolicy
      can [:create, :read, :update], [Patient, PatientProfile]
      can [:create, :read, :update], Appointment
      can :read, AppointmentNote
      can [:read, :update, :create], LabTest
      can :manage, LabTestResult
      can :read, MedicalRecord
      can :read, Prescription
      can :read, PrescriptionItem
      can :read, TreatmentAssignment
      can :read, [Ward, Room, Department, Hospital, Treatment, Medicine, Specialization]
      can :read, [DoctorProfile, StaffProfile]
      can :manage, Document

      if user.staff_profile
        can :update, StaffProfile, id: user.staff_profile.id
      end

    elsif user.patient?
      can :read, [Hospital, Department, DoctorProfile]

      # MUST BE ACCESSIBLE EVEN BEFORE PATIENT RECORD IS CREATED
      can [:new, :create], Appointment
      can [:new, :create], PatientProfile

      if user.patient
        pat_id = user.patient.id

        # Appointments scoped to patient
        can :read, Appointment, patient_id: pat_id
        can :destroy, Appointment, patient_id: pat_id
        can :read, AppointmentNote, appointment: { patient_id: pat_id }

        # Medical Records & Treatments
        can :read, MedicalRecord, patient_id: pat_id
        can :read, TreatmentAssignment, medical_record: { patient_id: pat_id }

        # Prescriptions & Items
        can :read, Prescription, patient_id: pat_id
        can :read, PrescriptionItem, prescription: { patient_id: pat_id }

        # Lab Tests & Results
        can :read, LabTest, patient_id: pat_id
        can :read, LabTestResult, lab_test: { patient_id: pat_id }

        # Admissions
        can :read, Admission, patient_id: pat_id

        # Invoices & Payments
        can :read, Invoice, patient_id: pat_id
        can :read, InvoiceItem, invoice: { patient_id: pat_id }
        can :read, Payment, invoice: { patient_id: pat_id }

        # Insurance Policies
        can :read, InsurancePolicy, patient_id: pat_id

        # Documents
        can :read, Document, documentable_type: 'Patient', documentable_id: pat_id

        # Patient Profile & Read Access
        can :read, Patient, id: pat_id
        can :update, Patient, id: pat_id
        can [:read, :update], PatientProfile, patient_id: pat_id
      end
    end
  end
end