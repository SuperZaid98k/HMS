class CreatePatientProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :patient_profiles do |t|
      t.integer :patient_id
      t.string :first_name
      t.string :last_name
      t.string :date_of_birth
      t.string :gender
      t.string :phone
      t.string :address
      t.string :blood_group

      t.timestamps
    end
  end
end
