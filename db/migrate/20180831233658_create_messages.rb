class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :sender_id, null: false
      t.integer :room_id, null: false
      t.text :body
      t.datetime :created_at, null: false
    end
  end
end
