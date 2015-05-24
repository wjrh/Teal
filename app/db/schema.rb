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

ActiveRecord::Schema.define(version: 20150412152637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airings", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "listens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "episode_id"
  end

  add_index "airings", ["episode_id"], name: "index_airings_on_episode_id", using: :btree

  create_table "djs", force: :cascade do |t|
    t.string   "net_id"
    t.string   "email"
    t.string   "dj_name"
    t.string   "real_name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "djs_episodes", id: false, force: :cascade do |t|
    t.integer "dj_id",      null: false
    t.integer "episode_id", null: false
  end

  add_index "djs_episodes", ["dj_id", "episode_id"], name: "index_djs_episodes_on_dj_id_and_episode_id", using: :btree
  add_index "djs_episodes", ["episode_id", "dj_id"], name: "index_djs_episodes_on_episode_id_and_dj_id", using: :btree

  create_table "djs_shows", id: false, force: :cascade do |t|
    t.integer "dj_id",   null: false
    t.integer "show_id", null: false
  end

  add_index "djs_shows", ["dj_id", "show_id"], name: "index_djs_shows_on_dj_id_and_show_id", using: :btree
  add_index "djs_shows", ["show_id", "dj_id"], name: "index_djs_shows_on_show_id_and_dj_id", using: :btree

  create_table "episodes", force: :cascade do |t|
    t.string   "name"
    t.string   "recording_url"
    t.boolean  "downloadable"
    t.integer  "online_listens"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "show_id"
    t.text     "description"
  end

  add_index "episodes", ["show_id"], name: "index_episodes_on_show_id", using: :btree

  create_table "episodes_songs", id: false, force: :cascade do |t|
    t.integer "song_id",            null: false
    t.integer "episode_id",         null: false
    t.integer "seconds_from_start"
  end

  add_index "episodes_songs", ["episode_id", "song_id"], name: "index_episodes_songs_on_episode_id_and_song_id", using: :btree
  add_index "episodes_songs", ["song_id", "episode_id"], name: "index_episodes_songs_on_song_id_and_episode_id", using: :btree

  create_table "shows", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "songs", force: :cascade do |t|
    t.string   "artist"
    t.string   "title"
    t.string   "ISRC"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "airings", "episodes"
  add_foreign_key "episodes", "shows"
end
