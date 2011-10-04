class AddDocumentAttachmentToAccounting < ActiveRecord::Migration
  def change
    add_column :accountings, :document_file_name, :string
    add_column :accountings, :document_content_type, :string
    add_column :accountings, :document_file_size, :integer
    add_column :accountings, :document_updated_at, :datetime
  end
end
