class CreateLabTestResults < ActiveRecord::Migration[8.1]
  def change
    create_table :lab_test_results do |t|
      t.integer :lab_test_id
      t.string :result
      t.string :unit
      t.string :reference_range
      t.string :tested_at

      t.timestamps
    end
  end
end
