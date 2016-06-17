class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.uuid :user_id
      t.string :povider
      t.string :uid

      t.timestamps null: false
    end
  end
end
