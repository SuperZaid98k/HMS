class CreateRooms < ActiveRecord::Migration[8.1]
  def change
    create_table :rooms do |t|
      t.integer :ward_id
      t.string :room_number
      t.string :room_type

      t.timestamps
    end
  end
end
