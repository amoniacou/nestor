class CreateGroupsChats < ActiveRecord::Migration[5.2]
  def change
    create_table :groups_chats do |t|
      t.integer :room_id
      t.string :service, null: false
      t.string :service_id, null: false
      t.datetime :created_at, null: false
    end
  end
end
