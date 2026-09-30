class CreatePrescriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :prescriptions do |t|
      t.integer :patient_id
      t.integer :doctor_profile_id
      t.integer :medical_record_id
      t.string :prescribed_at

      t.timestamps
    end
  end
end
