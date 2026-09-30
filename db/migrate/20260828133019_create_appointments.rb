class CreateAppointments < ActiveRecord::Migration[8.1]
  def change
    create_table :appointments do |t|
      t.integer :patient_id
      t.integer :doctor_profile_id
      t.string :scheduled_at
      t.string :status
      t.string :reason

      t.timestamps
    end
  end
end
