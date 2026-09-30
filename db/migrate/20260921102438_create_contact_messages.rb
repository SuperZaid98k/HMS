class CreateContactMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :contact_messages do |t|
      t.string :name
      t.string :contact_no
      t.string :email
      t.text :message
      t.string :status

      t.timestamps
    end
  end
end
