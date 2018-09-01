class CreateMessengers < ActiveRecord::Migration[5.2]
  def change
    create_table :messengers do |t|
      t.integer :user_id
      t.string :service, null: false
      t.string :service_id, null: false
      t.jsonb :data, null: false, default: {}
      t.timestamps
    end
  end
end
