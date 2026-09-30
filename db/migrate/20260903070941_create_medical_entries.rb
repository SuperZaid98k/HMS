class CreateMedicalEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :medical_entries do |t|
      t.string :entryable_type
      t.integer :entryable_id
      t.integer :patient_id

      t.timestamps
    end
  end
end
