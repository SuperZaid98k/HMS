class RenameTypeToRoleInUsers < ActiveRecord::Migration[7.1]
  def change
    # syntax: rename_column :table_name, :old_column_name, :new_column_name
    rename_column :users, :type, :role
  end
end