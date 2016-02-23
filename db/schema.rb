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

ActiveRecord::Schema.define(version: 20160222191720) do

  create_table "candidates", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "name"
    t.string   "cand_id"
    t.string   "party"
    t.string   "office"
    t.integer  "total_raised"
    t.integer  "total_spent"
    t.integer  "debt"
    t.integer  "cash"
    t.integer  "in_kind"
    t.integer  "anon"
    t.integer  "personal"
    t.integer  "misc"
    t.integer  "small"
  end

  create_table "contributions", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "contributor"
    t.string   "date"
    t.integer  "amount"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "employer"
    t.string   "occupation"
  end

  create_table "elections", force: :cascade do |t|
    t.string   "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
