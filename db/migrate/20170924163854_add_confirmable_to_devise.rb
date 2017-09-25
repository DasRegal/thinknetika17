class AddConfirmableToDevise < ActiveRecord::Migration[5.1]
  # Note: You can't use change, as User.update_all will fail in the down migration
  def up
    add_column :users, :confirmation_token, :string
    add_column :users, :is_confirmed, :boolean, default: true
    add_index :users, :confirmation_token, unique: true

    User.all.update_all is_confirmed: true
  end

  def down
    remove_columns :users, :confirmation_token, :is_confirmed
  end
end
