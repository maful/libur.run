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

ActiveRecord::Schema[7.0].define(version: 2023_01_20_071019) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "account_login_change_keys", force: :cascade do |t|
    t.string "key", null: false
    t.string "login", null: false
    t.datetime "deadline", null: false
  end

  create_table "account_password_reset_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "account_remember_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
  end

  create_table "account_verification_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "requested_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.integer "status", default: 1, null: false
    t.citext "email", null: false
    t.string "password_hash"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.index ["email"], name: "index_accounts_on_email", unique: true, where: "(status = ANY (ARRAY[1, 2]))"
    t.index ["invitation_token"], name: "index_accounts_on_invitation_token", unique: true
  end

  create_table "action_markdown_markdown_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_markdown_markdown_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "public_id", limit: 19, null: false
    t.string "line_1", null: false
    t.string "line_2"
    t.string "country_code", limit: 2, null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip", limit: 10, null: false
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable", unique: true
    t.index ["public_id"], name: "index_addresses_on_public_id", unique: true
  end

  create_table "assignments", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_assignments_on_employee_id"
    t.index ["role_id"], name: "index_assignments_on_role_id"
  end

  create_table "claim_groups", force: :cascade do |t|
    t.string "public_id", limit: 19, null: false
    t.string "name", limit: 50, null: false
    t.datetime "submission_date", null: false
    t.integer "approval_status", limit: 2, null: false
    t.datetime "approval_date"
    t.string "comment", limit: 100
    t.integer "total_amount_cents", default: 0, null: false
    t.string "total_amount_currency", default: "USD", null: false
    t.bigint "employee_id"
    t.bigint "approver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approver_id"], name: "index_claim_groups_on_approver_id"
    t.index ["employee_id"], name: "index_claim_groups_on_employee_id"
    t.index ["public_id"], name: "index_claim_groups_on_public_id", unique: true
  end

  create_table "claim_types", force: :cascade do |t|
    t.string "public_id", limit: 19, null: false
    t.string "name", limit: 50, null: false
    t.string "description", limit: 100
    t.boolean "status", default: true
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["public_id"], name: "index_claim_types_on_public_id", unique: true
    t.index ["year", "name"], name: "index_claim_types_on_year_and_name", unique: true
  end

  create_table "claims", force: :cascade do |t|
    t.string "public_id", limit: 19, null: false
    t.bigint "claim_group_id"
    t.bigint "claim_type_id"
    t.bigint "employee_id"
    t.date "issue_date", null: false
    t.string "note", limit: 200
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["claim_group_id"], name: "index_claims_on_claim_group_id"
    t.index ["claim_type_id"], name: "index_claims_on_claim_type_id"
    t.index ["employee_id"], name: "index_claims_on_employee_id"
    t.index ["public_id"], name: "index_claims_on_public_id", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "public_id", limit: 19, null: false
    t.string "name", null: false
    t.string "website"
    t.string "email", null: false
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "finance_approver_id"
    t.index ["email"], name: "index_companies_on_email", unique: true
    t.index ["finance_approver_id"], name: "index_companies_on_finance_approver_id"
    t.index ["public_id"], name: "index_companies_on_public_id", unique: true
  end

  create_table "employees", force: :cascade do |t|
    t.string "public_id", limit: 19, null: false
    t.string "name", null: false
    t.string "position"
    t.date "start_date"
    t.integer "status", limit: 2, default: 0
    t.integer "marital_status", limit: 2
    t.integer "religion", limit: 2
    t.string "citizenship", limit: 2
    t.string "identity_number"
    t.string "passport_number"
    t.date "birthday"
    t.string "phone_number"
    t.string "country_of_work", limit: 2
    t.bigint "account_id"
    t.bigint "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_employees_on_account_id"
    t.index ["manager_id"], name: "index_employees_on_manager_id"
    t.index ["public_id"], name: "index_employees_on_public_id", unique: true
  end

  create_table "leave_balances", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "leave_type_id"
    t.decimal "entitled_balance", precision: 4, scale: 2, null: false
    t.decimal "remaining_balance", precision: 4, scale: 2, null: false
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "leave_type_id", "year"], name: "index_leave_balances_on_employee_id_and_leave_type_id_and_year", unique: true
    t.index ["employee_id"], name: "index_leave_balances_on_employee_id"
    t.index ["leave_type_id"], name: "index_leave_balances_on_leave_type_id"
    t.index ["year"], name: "index_leave_balances_on_year"
  end

  create_table "leave_types", force: :cascade do |t|
    t.string "public_id", limit: 19, null: false
    t.string "name", null: false
    t.integer "days_per_year", null: false
    t.integer "year", null: false
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["year"], name: "index_leave_types_on_year"
  end

  create_table "leaves", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "manager_id"
    t.bigint "leave_type_id"
    t.string "public_id", limit: 19, null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.string "note", limit: 100
    t.decimal "number_of_days", precision: 4, scale: 2, null: false
    t.boolean "half_day", default: false
    t.string "half_day_time"
    t.integer "approval_status", null: false
    t.datetime "approval_date"
    t.string "comment", limit: 100
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_leaves_on_employee_id"
    t.index ["leave_type_id"], name: "index_leaves_on_leave_type_id"
    t.index ["manager_id"], name: "index_leaves_on_manager_id"
    t.index ["year"], name: "index_leaves_on_year"
  end

  create_table "onboardings", force: :cascade do |t|
    t.bigint "employee_id"
    t.integer "state", limit: 2, default: 0, null: false
    t.boolean "subscribe", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_onboardings_on_employee_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.string "public_id", limit: 19, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
    t.index ["public_id"], name: "index_roles_on_public_id", unique: true
  end

  add_foreign_key "account_login_change_keys", "accounts", column: "id"
  add_foreign_key "account_password_reset_keys", "accounts", column: "id"
  add_foreign_key "account_remember_keys", "accounts", column: "id"
  add_foreign_key "account_verification_keys", "accounts", column: "id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "claim_groups", "employees", column: "approver_id"
  add_foreign_key "companies", "employees", column: "finance_approver_id", on_delete: :nullify
  add_foreign_key "employees", "accounts"
  add_foreign_key "employees", "employees", column: "manager_id"
  add_foreign_key "leaves", "employees", column: "manager_id"
end
