class CreateTreatmentAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :treatment_assignments do |t|
      t.integer :medical_record_id
      t.integer :treatment_id
      t.string :notes
      t.string :started_at
      t.string :completed_at

      t.timestamps
    end
  end
end
