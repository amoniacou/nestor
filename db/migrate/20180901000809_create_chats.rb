class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :room_id
      t.string :service
      t.string :service_group

      t.timestamps
    end
  end
end
