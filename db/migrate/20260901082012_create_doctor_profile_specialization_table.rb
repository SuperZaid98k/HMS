class CreateDoctorProfileSpecializationTable < ActiveRecord::Migration[8.1]
  def change
    create_table :doctor_profiles_specializations, id: false  do |t|
      t.belongs_to :specialization
      t.belongs_to :doctor_profile
      t.timestamps
    end
  end
end
