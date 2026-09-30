class CreateInvoiceItems < ActiveRecord::Migration[8.1]
  def change
    create_table :invoice_items do |t|
      t.integer :invoice_id
      t.string :description
      t.string :amount
      t.string :quantity

      t.timestamps
    end
  end
end
