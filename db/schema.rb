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

ActiveRecord::Schema[7.0].define(version: 2026_01_06_034722) do
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

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "member_tags", "members"
  add_foreign_key "member_tags", "tags"
end
