class CreateHospitalRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :hospital_requests do |t|
      t.string :hospital_name, null: false
      t.string :contact_person_name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :city, null: false
      t.string :state
      t.text :address, null: false
      t.integer :total_beds
      t.text :specialties
      t.text :notes
      t.string :status, default: "pending", null: false

      t.timestamps
    end

    add_index :hospital_requests, :status
    add_index :hospital_requests, :email
  end
end