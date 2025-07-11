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

ActiveRecord::Schema[8.0].define(version: 2025_06_28_185747) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "buyers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "registration_number", default: "", null: false
    t.string "address", default: "", null: false
    t.string "contact_email", default: "", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.string "invoice_number"
    t.decimal "amount", precision: 10, scale: 2
    t.date "due_date"
    t.string "status"
    t.bigint "programme_id", null: false
    t.bigint "supplier_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["programme_id"], name: "index_invoices_on_programme_id"
    t.index ["supplier_id"], name: "index_invoices_on_supplier_id"
  end

  create_table "programmes", force: :cascade do |t|
    t.bigint "buyer_id", null: false
    t.string "name"
    t.decimal "limit"
    t.decimal "fee_percent"
    t.integer "maturity_days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_programmes_on_buyer_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "company"
    t.datetime "invited_at"
    t.string "invitation_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["email"], name: "index_suppliers_on_email", unique: true
    t.index ["user_id"], name: "index_suppliers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.integer "role", default: 0, null: false
    t.bigint "buyer_id"
    t.index ["buyer_id"], name: "index_users_on_buyer_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "invoices", "programmes"
  add_foreign_key "invoices", "suppliers"
  add_foreign_key "programmes", "buyers"
  add_foreign_key "suppliers", "users"
  add_foreign_key "users", "buyers"
end
