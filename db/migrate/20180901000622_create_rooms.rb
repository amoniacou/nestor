class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    enable_extension("citext")
    create_table :rooms do |t|
      t.citext :name, null: false
      t.timestamps
    end
    add_index :rooms, :name, unique: true
  end
end
