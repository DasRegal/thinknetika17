class RenameIndexesRemoveForeignKey < ActiveRecord::Migration[5.1]
  def change
    remove_index :attachments, :attachmentable_id
    remove_index :attachments, :attachmentable_type

    add_index :attachments, [:attachmentable_id, :attachmentable_type]
    remove_foreign_key :attachments, :questions

  end
end
