class AddLinksAndAttachmentsToMilestones < ActiveRecord::Migration
  def change
    add_column :milestones, :document_file_name, :string
    add_column :milestones, :document_content_type, :string
    add_column :milestones, :document_file_size, :string
    add_column :milestones, :document_updated_at, :string
    add_column :milestones, :url, :string
  end
end
