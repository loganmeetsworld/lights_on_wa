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

ActiveRecord::Schema.define(version: 20160301021813) do

  create_table "candidates", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "pdc_id"
    t.string   "name"
    t.string   "year"
    t.string   "office"
    t.string   "party"
    t.integer  "raised"
    t.integer  "spent"
    t.integer  "debt"
    t.integer  "ind_spend"
    t.integer  "ind_opp"
    t.string   "dist"
    t.string   "pos"
    t.string   "court"
    t.string   "locality"
    t.integer  "user_id"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "pdc_id_year"
    t.string   "office_type"
  end

  add_index "candidates", ["pdc_id_year"], name: "candidate_id_index"

  create_table "candidates_to_users", force: :cascade do |t|
    t.integer  "candidate_id"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "contributions", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "date"
    t.integer  "amount"
    t.string   "candidate_id"
    t.string   "cont_type"
    t.string   "description"
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "employer"
    t.string   "occupation"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "uid"
    t.string   "username"
    t.string   "image_url"
    t.string   "provider"
  end

end
