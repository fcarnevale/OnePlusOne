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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130624073250) do

  create_table "memberships", :force => true do |t|
    t.integer  "person_id"
    t.integer  "team_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "memberships", ["person_id", "team_id"], :name => "index_memberships_on_person_id_and_team_id", :unique => true
  add_index "memberships", ["person_id"], :name => "index_memberships_on_person_id"
  add_index "memberships", ["team_id"], :name => "index_memberships_on_team_id"

  create_table "partnerships", :force => true do |t|
    t.integer  "person_id"
    t.integer  "partner_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "partnerships", ["partner_id"], :name => "index_partnerships_on_partner_id"
  add_index "partnerships", ["person_id", "partner_id"], :name => "index_partnerships_on_person_id_and_partner_id"
  add_index "partnerships", ["person_id"], :name => "index_partnerships_on_person_id"

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "teams_count",              :default => 0
    t.boolean  "paired",                   :default => false
    t.integer  "potential_partners_count", :default => 0
  end

  add_index "people", ["email"], :name => "index_people_on_email", :unique => true

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
