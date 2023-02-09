# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141218082223) do

  create_table "puppies", force: true do |t|
    t.string   "name"
    t.string   "breed"
    t.string   "sex"
    t.string   "age"
    t.string   "fun_fact"
    t.integer  "score_touchdowns",  default: 0, null: false
    t.integer  "score_penalties",   default: 0, null: false
    t.integer  "score_takeaways",   default: 0, null: false
    t.integer  "score_tackles",     default: 0, null: false
    t.string   "pic"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "team_name"
    t.string   "big_pic"
    t.integer  "score_field_goals", default: 0
  end

  create_table "puppy_teams", force: true do |t|
    t.integer  "puppy_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.datetime "begin_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "TEAM_NAME"
    t.string   "TEAM_DESCRIPTION"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pup1"
    t.integer  "pup2"
    t.integer  "pup3"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "image_url"
    t.string   "role"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "video_provider"
    t.string   "vote"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "video_providers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
