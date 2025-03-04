# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_04_214849) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "animals", force: :cascade do |t|
    t.string "name"
    t.integer "level"
    t.integer "group"
    t.integer "habitat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "animals_games", id: false, force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "animal_id", null: false
    t.index ["animal_id", "game_id"], name: "index_animals_games_on_animal_id_and_game_id"
    t.index ["game_id", "animal_id"], name: "index_animals_games_on_game_id_and_animal_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
