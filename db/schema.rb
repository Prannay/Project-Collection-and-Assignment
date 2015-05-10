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

ActiveRecord::Schema.define(version: 20150510080006) do

  create_table "assignments", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "assignments", ["project_id"], name: "index_assignments_on_project_id"
  add_index "assignments", ["team_id"], name: "index_assignments_on_team_id"

  create_table "preassignments", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "project_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "preferences", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "value"
  end

  add_index "preferences", ["project_id"], name: "index_preferences_on_project_id"
  add_index "preferences", ["team_id", "project_id"], name: "index_preferences_on_team_id_and_project_id", unique: true
  add_index "preferences", ["team_id"], name: "index_preferences_on_team_id"

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.string   "organization"
    t.text     "contact"
    t.text     "description"
    t.boolean  "oncampus"
    t.boolean  "islegacy"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "approved",     default: false
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "relationships", ["team_id"], name: "index_relationships_on_team_id"
  add_index "relationships", ["user_id", "team_id"], name: "index_relationships_on_user_id_and_team_id", unique: true
  add_index "relationships", ["user_id"], name: "index_relationships_on_user_id"

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code"
  end

  add_index "teams", ["name"], name: "index_teams_on_name", unique: true
  add_index "teams", ["user_id"], name: "index_teams_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
