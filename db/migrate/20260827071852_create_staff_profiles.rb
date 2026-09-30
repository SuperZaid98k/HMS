class CreateStaffProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :staff_profiles do |t|
      t.integer :user_id
      t.string :employee_number
      t.integer :department_id
      t.string :joining_date
      t.string :phone

      t.timestamps
    end
  end
end
