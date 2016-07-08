class CreateTableLanding < ActiveRecord::Migration
  def change
    create_table :landings, id: :uuid do |t|
      t.text :search

      t.timestamps null: false
    end
  end
end
