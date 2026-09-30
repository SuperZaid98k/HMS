class AddNameToDoctorProfile < ActiveRecord::Migration[8.1]
  def change
    add_column :doctor_profiles, :name, :string
  end
end
