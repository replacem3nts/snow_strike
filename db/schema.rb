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

ActiveRecord::Schema.define(version: 2020_03_27_023228) do

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "mountain_id"
  end

  create_table "forecasts", force: :cascade do |t|
    t.integer "mountain_id"
    t.integer "hist_snow"
    t.integer "snow_this_yr"
    t.integer "snow_next_three_days"
    t.integer "snow_next_seven_days"
    t.date "year_start"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mountains", force: :cascade do |t|
    t.string "name"
    t.string "state"
    t.string "zip_code"
  end

  create_table "trips", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.integer "mountain_id"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "skier_type"
    t.string "hometown"
    t.string "age"
  end

end
