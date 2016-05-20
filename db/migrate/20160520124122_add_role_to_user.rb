class AddRoleToUser < ActiveRecord::Migration
  def change
    # add_column :users, :role_id, :integer
    add_reference :users, :role, index: true, foreign_key: true
  end
end
