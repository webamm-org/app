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

ActiveRecord::Schema[7.2].define(version: 2024_08_11_112430) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "authentications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "database_schema_model_id", null: false
    t.uuid "plan_id", null: false
    t.jsonb "options", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["database_schema_model_id"], name: "index_authentications_on_database_schema_model_id"
    t.index ["plan_id"], name: "index_authentications_on_plan_id"
  end

  create_table "database_schema_associations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "connection_type", default: 0, null: false
    t.jsonb "connection_options", default: {}, null: false
    t.uuid "source_database_schema_model_id", null: false
    t.uuid "destination_database_schema_model_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_database_schema_model_id"], name: "idx_on_destination_database_schema_model_id_0d16a03465"
    t.index ["source_database_schema_model_id"], name: "idx_on_source_database_schema_model_id_6f0519a3ff"
  end

  create_table "database_schema_columns", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "database_schema_model_id", null: false
    t.string "name", null: false
    t.integer "field_type", default: 0, null: false
    t.boolean "can_be_null", default: false, null: false
    t.string "default_value"
    t.jsonb "options", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["database_schema_model_id", "name"], name: "idx_on_database_schema_model_id_name_43628ba657", unique: true
    t.index ["database_schema_model_id"], name: "index_database_schema_columns_on_database_schema_model_id"
  end

  create_table "database_schema_columns_indices", id: false, force: :cascade do |t|
    t.uuid "database_schema_index_id", null: false
    t.uuid "database_schema_column_id", null: false
    t.index ["database_schema_column_id"], name: "idx_on_database_schema_column_id_39f5b9518e"
    t.index ["database_schema_index_id"], name: "idx_on_database_schema_index_id_de6141deb6"
  end

  create_table "database_schema_indices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "database_schema_model_id", null: false
    t.boolean "is_unique", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["database_schema_model_id"], name: "index_database_schema_indices_on_database_schema_model_id"
  end

  create_table "database_schema_models", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "plan_id", null: false
    t.text "description"
    t.jsonb "options", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id", "name"], name: "index_database_schema_models_on_plan_id_and_name", unique: true
    t.index ["plan_id"], name: "index_database_schema_models_on_plan_id"
  end

  create_table "leads", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_leads_on_email", unique: true
  end

  create_table "plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "ai_enabled", default: false
    t.integer "usd_rate", default: 0
    t.boolean "started", default: false
    t.index ["user_id"], name: "index_plans_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "ai_enabled", default: false
    t.index ["email"], name: "idx_users_email", unique: true
    t.index ["invitation_token"], name: "idx_users_invitation_token", unique: true
    t.index ["reset_password_token"], name: "idx_users_reset_password_token", unique: true
  end

  add_foreign_key "authentications", "database_schema_models"
  add_foreign_key "authentications", "plans"
  add_foreign_key "database_schema_associations", "database_schema_models", column: "destination_database_schema_model_id"
  add_foreign_key "database_schema_associations", "database_schema_models", column: "source_database_schema_model_id"
  add_foreign_key "database_schema_columns", "database_schema_models"
  add_foreign_key "database_schema_columns_indices", "database_schema_columns"
  add_foreign_key "database_schema_columns_indices", "database_schema_indices"
  add_foreign_key "database_schema_indices", "database_schema_models"
  add_foreign_key "database_schema_models", "plans"
  add_foreign_key "plans", "users"
end
