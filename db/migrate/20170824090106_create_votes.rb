class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.references :user
      t.string :voteable_type
      t.integer :voteable_id
      t.integer :status
      t.timestamps
    end
    add_index :votes, [:voteable_id, :voteable_type]
  end
end
