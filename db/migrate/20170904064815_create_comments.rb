class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :user
      t.string :commentable_type
      t.integer :commentable_id
      t.text :body
      t.timestamps
    end
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
