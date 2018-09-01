class CreateMessengers < ActiveRecord::Migration[5.2]
  def change
    create_table :messengers do |t|
      t.integer :user_id, null: false
      t.string :service, null: false
      t.string :account, null: false
      t.timestamps
    end
  end
end
