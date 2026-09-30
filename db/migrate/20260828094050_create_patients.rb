class CreatePatients < ActiveRecord::Migration[8.1]
  def change
    create_table :patients do |t|
      t.string :patient_number

      t.timestamps
    end
  end
end
