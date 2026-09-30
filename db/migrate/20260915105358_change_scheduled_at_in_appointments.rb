class ChangeScheduledAtInAppointments < ActiveRecord::Migration[8.1]
  def change
    change_column :appointments, :scheduled_at, :datetime
  end
end