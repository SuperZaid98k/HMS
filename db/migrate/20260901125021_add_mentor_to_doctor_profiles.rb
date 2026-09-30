class AddMentorToDoctorProfiles < ActiveRecord::Migration[8.1]
  def change
    remove_column :doctor_profiles, :mentor_id
    add_reference :doctor_profiles, :mentor, null: true, foreign_key: {to_table: :doctor_profiles},index: true
  end
end
