class CreateAdmissions < ActiveRecord::Migration[8.1]
  def change
    create_table :admissions do |t|
      t.integer :patient_id
      t.integer :bed_id
      t.string :admitted_at
      t.string :discharged_at
      t.string :status

      t.timestamps
    end
  end
end
