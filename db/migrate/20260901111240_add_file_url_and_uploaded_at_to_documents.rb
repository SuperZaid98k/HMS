class AddFileUrlAndUploadedAtToDocuments < ActiveRecord::Migration[8.1]
  def change
    add_column :documents, :file_url, :string
    add_column :documents, :uploaded_at, :string
  end
end
