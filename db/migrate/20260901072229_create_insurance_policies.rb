class CreateInsurancePolicies < ActiveRecord::Migration[8.1]
  def change
    create_table :insurance_policies do |t|
      t.integer :patient_id
      t.string :provider_name
      t.string :policy_number
      t.string :coverage_amount
      t.string :valid_from
      t.string :valid_until

      t.timestamps
    end
  end
end
