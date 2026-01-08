# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2026_01_07_201341) do
  create_table "blocked_members", force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "blocked_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked_id"], name: "index_blocked_members_on_blocked_id"
    t.index ["member_id", "blocked_id"], name: "index_blocked_members_on_member_id_and_blocked_id", unique: true
    t.index ["member_id"], name: "index_blocked_members_on_member_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "bookmarked_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bookmarked_id"], name: "index_bookmarks_on_bookmarked_id"
    t.index ["member_id", "bookmarked_id"], name: "index_bookmarks_on_member_id_and_bookmarked_id", unique: true
    t.index ["member_id"], name: "index_bookmarks_on_member_id"
  end

  create_table "chats", force: :cascade do |t|
    t.integer "reservation_id", null: false
    t.integer "member_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_chats_on_member_id"
    t.index ["reservation_id"], name: "index_chats_on_reservation_id"
  end

  create_table "free_dates", force: :cascade do |t|
    t.integer "member_id", null: false
    t.datetime "free_hour", null: false
    t.string "day", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_free_dates_on_member_id"
  end

  create_table "member_regions", force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "region_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_member_regions_on_member_id"
    t.index ["region_id"], name: "index_member_regions_on_region_id"
  end

  create_table "member_tags", force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_member_tags_on_member_id"
    t.index ["tag_id"], name: "index_member_tags_on_tag_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "name", null: false
    t.integer "sex", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.text "comment"
    t.date "birthday", null: false
    t.integer "price_per_hour"
    t.boolean "special_member", default: false
    t.boolean "is_banned", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_members_on_email", unique: true
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "target_member_id", null: false
    t.datetime "start_at", null: false
    t.integer "hours", null: false
    t.integer "status", default: 0, null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_reservations_on_member_id"
    t.index ["target_member_id"], name: "index_reservations_on_target_member_id"
  end

  create_table "reserved_dates", force: :cascade do |t|
    t.integer "reservation_id", null: false
    t.integer "target_member_id", null: false
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_reserved_dates_on_reservation_id"
    t.index ["target_member_id"], name: "index_reserved_dates_on_target_member_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "blocked_members", "members"
  add_foreign_key "blocked_members", "members", column: "blocked_id"
  add_foreign_key "bookmarks", "members"
  add_foreign_key "bookmarks", "members", column: "bookmarked_id"
  add_foreign_key "chats", "members"
  add_foreign_key "chats", "reservations"
  add_foreign_key "free_dates", "members"
  add_foreign_key "member_regions", "members"
  add_foreign_key "member_regions", "regions"
  add_foreign_key "member_tags", "members"
  add_foreign_key "member_tags", "tags"
  add_foreign_key "reservations", "members"
  add_foreign_key "reservations", "members", column: "target_member_id"
  add_foreign_key "reserved_dates", "members", column: "target_member_id"
  add_foreign_key "reserved_dates", "reservations"
end
