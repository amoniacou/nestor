# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_09_01_000809) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "groups_chats", force: :cascade do |t|
    t.integer "room_id"
    t.string "service", null: false
    t.string "service_id", null: false
    t.datetime "created_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "sender_id", null: false
    t.integer "room_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
  end

  create_table "messengers", force: :cascade do |t|
    t.integer "user_id"
    t.string "service", null: false
    t.string "service_id", null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.citext "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_rooms_on_name", unique: true
  end

  create_table "rooms_users", id: false, force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "user_id", null: false
    t.index ["room_id", "user_id"], name: "index_rooms_users_on_room_id_and_user_id"
  end

end
