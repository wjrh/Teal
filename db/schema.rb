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

ActiveRecord::Schema.define(version: 20150703015241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "creators", force: :cascade do |t|
    t.string   "lafayetteid"
    t.string   "email"
    t.string   "name"
    t.string   "real_name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "image_url"
  end

  create_table "creators_episodes", id: false, force: :cascade do |t|
    t.integer "creator_id", null: false
    t.integer "episode_id", null: false
  end

  add_index "creators_episodes", ["creator_id", "episode_id"], name: "index_creators_episodes_on_creator_id_and_episode_id", using: :btree
  add_index "creators_episodes", ["episode_id", "creator_id"], name: "index_creators_episodes_on_episode_id_and_creator_id", using: :btree

  create_table "creators_programs", id: false, force: :cascade do |t|
    t.integer "creator_id", null: false
    t.integer "program_id", null: false
  end

  add_index "creators_programs", ["creator_id", "program_id"], name: "index_creators_programs_on_creator_id_and_program_id", using: :btree
  add_index "creators_programs", ["program_id", "creator_id"], name: "index_creators_programs_on_program_id_and_creator_id", using: :btree

  create_table "episodes", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "recording_url"
    t.boolean  "downloadable"
    t.integer  "online_listens"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "program_id"
  end

  add_index "episodes", ["program_id"], name: "index_episodes_on_program_id", using: :btree

  create_table "playouts", force: :cascade do |t|
    t.integer  "episode_id"
    t.integer  "song_id"
    t.integer  "live_listeners"
    t.integer  "soundexchange_reporting", default: 1
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "programs", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "songs", force: :cascade do |t|
    t.string   "artist"
    t.string   "title"
    t.string   "ISRC"
    t.string   "album"
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "episodes", "programs"
  add_foreign_key "playouts", "episodes"
  add_foreign_key "playouts", "songs"
end
