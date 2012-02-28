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

ActiveRecord::Schema.define(:version => 20120227205726) do

  create_table "profiles", :force => true do |t|
    t.date     "birthday"
    t.string   "sex"
    t.string   "home_town"
    t.string   "about_block"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "cred",        :default => 0
    t.integer  "user_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "ride_options", :force => true do |t|
    t.integer  "passenger_count"
    t.integer  "cost"
    t.string   "meeting_place"
    t.string   "radio"
    t.string   "music"
    t.string   "smoking"
    t.string   "bikes"
    t.text     "message"
    t.string   "passengers"
    t.integer  "ride_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "rides", :force => true do |t|
    t.string   "origin"
    t.string   "originstate"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "destination"
    t.string   "destinationstate"
    t.float    "bearing"
    t.float    "trip_distance"
    t.datetime "datetime"
    t.string   "message"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "rides", ["datetime"], :name => "index_rides_on_datetime"
  add_index "rides", ["origin"], :name => "index_rides_on_origin"
  add_index "rides", ["user_id"], :name => "index_rides_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
