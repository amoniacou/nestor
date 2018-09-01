class CreateMessangers < ActiveRecord::Migration[5.2]
  def change
    create_table :messangers do |t|
      t.integer :user_id
      t.string :service
      t.string :account

      t.timestamps
    end
  end
end
