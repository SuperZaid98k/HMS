class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.integer :invoice_id
      t.string :amount
      t.string :payment_method
      t.string :status
      t.string :paid_at

      t.timestamps
    end
  end
end
