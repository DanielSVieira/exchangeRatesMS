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

ActiveRecord::Schema[8.1].define(version: 2025_12_22_225050) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "exchange_rates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency_from"
    t.string "currency_to"
    t.datetime "fetched_at"
    t.decimal "rate"
    t.datetime "updated_at", null: false
    t.index ["currency_from", "currency_to"], name: "index_exchange_rates_on_currency_from_and_currency_to", unique: true
  end

  create_table "exchange_rates_raws", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency_from"
    t.datetime "fetched_at"
    t.jsonb "rates"
    t.datetime "updated_at", null: false
  end
end
