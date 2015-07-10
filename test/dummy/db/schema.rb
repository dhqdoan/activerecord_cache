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

ActiveRecord::Schema.define(version: 20150709151200) do

  create_table "associated_records", force: :cascade do |t|
    t.integer  "cached_record_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "associated_records", ["cached_record_id"], name: "index_associated_records_on_cached_record_id"

  create_table "cached_records", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "cached_type_a_records", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cached_type_b_records", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "non_primary_associateds", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "poly_records", force: :cascade do |t|
    t.string   "name"
    t.integer  "detail_id"
    t.string   "detail_type"
    t.integer  "cached_type_b_record_id"
    t.integer  "cached_type_a_record_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "poly_records", ["detail_type", "detail_id"], name: "index_poly_records_on_detail_type_and_detail_id"

end
