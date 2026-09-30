class CreateAppointmentNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :appointment_notes do |t|
      t.integer :appointment_id
      t.integer :user_id
      t.string :content
      t.timestamps
    end
  end
end
