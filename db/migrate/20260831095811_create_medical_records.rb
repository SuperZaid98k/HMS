class CreateMedicalRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :medical_records do |t|
      t.integer :patient_id
      t.integer :doctor_profile_id
      t.integer :appointment_id
      t.string :diagnosis
      t.string :description

      t.timestamps
    end
  end
end
