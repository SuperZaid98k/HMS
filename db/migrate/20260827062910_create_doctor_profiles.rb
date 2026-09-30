class CreateDoctorProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :doctor_profiles do |t|
      t.integer :user_id
      t.integer :department_id
      t.string :license_number
      t.string :experience_years
      t.integer :mentor_id

      t.timestamps
    end
  end
end
