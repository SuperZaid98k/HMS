class CreateWards < ActiveRecord::Migration[8.1]
  def change
    create_table :wards do |t|
      t.integer :hospital_id
      t.string :name
      t.string :ward_type

      t.timestamps
    end
  end
end
