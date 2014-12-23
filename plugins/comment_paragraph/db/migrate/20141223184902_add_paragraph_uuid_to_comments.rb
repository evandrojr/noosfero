class AddParagraphUuidToComments < ActiveRecord::Migration
  def change
    add_column :comments, :paragraph_uuid, :string unless column_exists?(:comments, :paragraph_uuid)
    add_index :comments, :paragraph_uuid
  end
end
