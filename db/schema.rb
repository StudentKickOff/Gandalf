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

ActiveRecord::Schema.define(version: 20140913142443) do

  create_table "access_levels", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "capacity"
    t.integer  "price"
    t.boolean  "public",                  default: true
    t.boolean  "has_comment"
    t.boolean  "hidden"
    t.boolean  "member_only"
  end

  add_index "access_levels", ["event_id"], name: "index_access_levels_on_event_id"

  create_table "access_levels_promos", id: false, force: :cascade do |t|
    t.integer "promo_id",        null: false
    t.integer "access_level_id", null: false
  end

  create_table "clubs", force: :cascade do |t|
    t.string   "full_name",     limit: 255
    t.string   "internal_name", limit: 255
    t.string   "display_name",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clubs_users", id: false, force: :cascade do |t|
    t.integer "club_id"
    t.integer "user_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "enrolled_clubs_members", id: false, force: :cascade do |t|
    t.integer "club_id", null: false
    t.integer "user_id", null: false
  end

  add_index "enrolled_clubs_members", ["club_id"], name: "index_enrolled_clubs_members_on_club_id"
  add_index "enrolled_clubs_members", ["user_id"], name: "index_enrolled_clubs_members_on_user_id"

  create_table "events", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "location",                limit: 255
    t.string   "website",                 limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "registration_open_date"
    t.datetime "registration_close_date"
    t.string   "bank_number",             limit: 255
    t.boolean  "show_ticket_count",                   default: true
    t.string   "contact_email",           limit: 255
    t.string   "export_file_name",        limit: 255
    t.string   "export_content_type",     limit: 255
    t.integer  "export_file_size"
    t.datetime "export_updated_at"
    t.boolean  "show_statistics"
    t.string   "export_status",           limit: 255
    t.integer  "club_id"
    t.boolean  "registration_open",                   default: true
  end

  create_table "orders", force: :cascade do |t|
    t.string   "status",       default: "initial"
    t.string   "name"
    t.string   "email"
    t.string   "gsm"
    t.integer  "ticket_id"
    t.integer  "event_id"
    t.integer  "paid"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payment_code"
  end

  add_index "orders", ["event_id"], name: "index_orders_on_event_id"

  create_table "partners", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255
    t.string   "authentication_token",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "event_id"
    t.integer  "access_level_id"
    t.boolean  "confirmed"
  end

  add_index "partners", ["access_level_id"], name: "index_partners_on_access_level_id"
  add_index "partners", ["authentication_token"], name: "index_partners_on_authentication_token"
  add_index "partners", ["reset_password_token"], name: "index_partners_on_reset_password_token", unique: true

  create_table "promos", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "code",         limit: 255
    t.integer  "limit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sold_tickets",             default: 0
  end

  add_index "promos", ["event_id"], name: "index_promos_on_event_id"

  create_table "registrations", force: :cascade do |t|
    t.string   "barcode",        limit: 255
    t.string   "name",           limit: 255
    t.string   "email",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "paid"
    t.string   "student_number", limit: 255
    t.integer  "price"
    t.datetime "checked_in_at"
    t.text     "comment"
    t.string   "barcode_data",   limit: 255
    t.string   "payment_code",   limit: 255
  end

  add_index "registrations", ["event_id"], name: "index_registrations_on_event_id"
  add_index "registrations", ["payment_code"], name: "index_registrations_on_payment_code", unique: true

  create_table "tickets", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "checked_in_at"
    t.integer  "order_id"
    t.string   "student_number"
    t.text     "comment"
    t.string   "barcode"
    t.string   "barcode_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "access_level_id"
    t.string   "status",          default: "initial"
  end

  add_index "tickets", ["access_level_id"], name: "index_tickets_on_access_level_id"
  add_index "tickets", ["order_id"], name: "index_tickets_on_order_id"

  create_table "users", force: :cascade do |t|
    t.string   "username",            limit: 255, default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",  limit: 255
    t.string   "last_sign_in_ip",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cas_givenname",       limit: 255
    t.string   "cas_surname",         limit: 255
    t.string   "cas_ugentStudentID",  limit: 255
    t.string   "cas_mail",            limit: 255
    t.string   "cas_uid",             limit: 255
    t.boolean  "admin"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255, null: false
    t.integer  "item_id",                    null: false
    t.string   "event",          limit: 255, null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end
