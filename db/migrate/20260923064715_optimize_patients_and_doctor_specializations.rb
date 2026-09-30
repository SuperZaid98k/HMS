class OptimizePatientsAndDoctorSpecializations < ActiveRecord::Migration[8.1]
  def change
    # 1. doctor_profiles_specializations:
    # Add unique composite index to prevent duplicate pairings
    add_index :doctor_profiles_specializations, 
              [:doctor_profile_id, :specialization_id], 
              unique: true, 
              name: "idx_doc_spec_unique" unless index_exists?(:doctor_profiles_specializations, [:doctor_profile_id, :specialization_id])

    # Enforce NOT NULL on join table foreign keys
    change_column_null :doctor_profiles_specializations, :doctor_profile_id, false
    change_column_null :doctor_profiles_specializations, :specialization_id, false

    # 2. patients table:
    # Upgrade user_id index to unique (remove old index first, then add unique)
    if index_exists?(:patients, :user_id)
      remove_index :patients, :user_id
    end
    add_index :patients, :user_id, unique: true

    # Index patient_number with uniqueness
    add_index :patients, :patient_number, unique: true unless index_exists?(:patients, :patient_number)
  end
end
