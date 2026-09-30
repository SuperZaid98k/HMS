class RenameRegisterationNumberToRegistrationNumber < ActiveRecord::Migration[8.1]
  def change
    rename_column :hospitals, :registeration_number, :registration_number
  end
end
