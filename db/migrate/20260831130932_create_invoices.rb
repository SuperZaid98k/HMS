class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.integer :patient_id
      t.integer :appointment_id
      t.string :invoice_number
      t.string :total_amount
      t.string :status
      t.string :issued_at

      t.timestamps
    end
  end
end
