class CreateLabTests < ActiveRecord::Migration[8.1]
  def change
    create_table :lab_tests do |t|
      t.integer :patient_id
      t.integer :doctor_profile_id
      t.string :test_name
      t.string :status
      t.string :requested_at

      t.timestamps
    end
  end
end
