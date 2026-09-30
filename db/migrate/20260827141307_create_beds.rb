class CreateBeds < ActiveRecord::Migration[8.1]
  def change
    create_table :beds do |t|
      t.integer :room_id
      t.string :bed_number
      t.string :status

      t.timestamps
    end
  end
end
