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

ActiveRecord::Schema.define(version: 20150601014642) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "loans", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "borrower_name"
    t.string   "description"
    t.datetime "application_date"
    t.datetime "disclose_by_date"
    t.datetime "earliest_closing_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "disclosures_delivered_date"
    t.datetime "disclosures_received_date"
    t.datetime "change_of_circumstance_date"
    t.datetime "revised_disclosures_delivered_date"
    t.datetime "revised_disclosures_received_date"
    t.datetime "closing_disclosures_delivered_date"
    t.datetime "closing_disclosures_received"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  default: "",    null: false
    t.boolean  "admin",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "authentication_token"
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
