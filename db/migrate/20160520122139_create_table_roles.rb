class CreateTableRoles < ActiveRecord::Migration
  def change
    create_table :table_roles do |t|
      t.string :role
      t.timestamps null: false
    end
    rename_table :table_roles, :roles
    rename_column :roles, :role, :name
  end
end
