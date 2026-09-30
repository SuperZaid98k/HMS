class CreatePrescriptionItems < ActiveRecord::Migration[8.1]
  def change
    create_table :prescription_items do |t|
      t.integer :prescription_id
      t.integer :medicine_id
      t.string :dosage
      t.string :frequency
      t.string :duration

      t.timestamps
    end
  end
end
