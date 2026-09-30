class CreateDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :documents do |t|
      t.string :name
      t.belongs_to :documentable, polymorphic: true

      t.timestamps
    end
  end
end
