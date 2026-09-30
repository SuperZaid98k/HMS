class CreateHospitals < ActiveRecord::Migration[8.1]
  def change
    create_table :hospitals do |t|
      t.string :name
      t.string :registeration_number
      t.string :phone
      t.string :email
      t.string :address

      t.timestamps
    end
  end
end
