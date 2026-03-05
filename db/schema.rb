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

ActiveRecord::Schema[7.2].define(version: 2026_03_05_024805) do
  create_table "departures", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
  end

  create_table "destinations", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
  end

  create_table "inquiries", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "subject"
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "service_type_id", null: false
    t.text "introduction"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_providers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_providers_on_reset_password_token", unique: true
  end

  create_table "quote_requests", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "service_id", null: false
    t.text "message"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "weight_kg", precision: 12, scale: 3
    t.decimal "volume_cbm", precision: 12, scale: 4
    t.integer "quantity"
    t.integer "incoterm_id"
    t.index ["service_id"], name: "index_quote_requests_on_service_id"
    t.index ["user_id"], name: "index_quote_requests_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.integer "departure_id", null: false
    t.integer "destination_id", null: false
    t.integer "service_type_id", null: false
    t.integer "price", null: false
    t.integer "lead_time", null: false
    t.integer "option_id", null: false
    t.text "description"
    t.integer "provider_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "service_scope_id", default: 1
    t.string "price_includes"
    t.integer "incoterm_id"
    t.string "price_type", default: "total", null: false
    t.string "price_unit"
    t.integer "container_size_id"
    t.index ["provider_id"], name: "index_services_on_provider_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "user_type_id", null: false
    t.integer "product_id", null: false
    t.text "introduction"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "quote_requests", "services"
  add_foreign_key "quote_requests", "users"
  add_foreign_key "services", "departures"
  add_foreign_key "services", "destinations"
  add_foreign_key "services", "providers"
end
