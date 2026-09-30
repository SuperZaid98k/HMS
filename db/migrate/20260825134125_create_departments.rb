class CreateDepartments < ActiveRecord::Migration[8.1]
  def change
    create_table :departments do |t|
      t.string :hospital_id
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end
