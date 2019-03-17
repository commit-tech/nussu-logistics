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

ActiveRecord::Schema.define(version: 20190316171248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "bookings", force: :cascade do |t|
    t.integer  "status"
    t.text     "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
    t.integer  "quantity"
    t.integer  "user_id",     :index=>{:name=>"index_bookings_on_user_id", :using=>:btree}
    t.integer  "item_id",     :index=>{:name=>"index_bookings_on_item_id", :using=>:btree}
  end

  create_table "items", force: :cascade do |t|
    t.citext   "name",        :default=>"", :null=>false, :index=>{:name=>"index_items_on_name", :unique=>true, :using=>:btree}
    t.text     "description", :default=>"", :null=>false
    t.integer  "quantity",    :null=>false
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",          :index=>{:name=>"index_roles_on_name_and_resource_type_and_resource_id", :with=>["resource_type", "resource_id"], :using=>:btree}
    t.string   "resource_type", :index=>{:name=>"index_roles_on_resource_type_and_resource_id", :with=>["resource_id"], :using=>:btree}
    t.integer  "resource_id"
    t.datetime "created_at",    :null=>false
    t.datetime "updated_at",    :null=>false
  end

  create_table "time_ranges", force: :cascade do |t|
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "timeslots", force: :cascade do |t|
    t.integer  "default_user_id", :index=>{:name=>"index_timeslots_on_default_user_id", :using=>:btree}
    t.integer  "time_range_id",   :index=>{:name=>"index_timeslots_on_time_range_id", :using=>:btree}
    t.datetime "created_at",      :null=>false
    t.datetime "updated_at",      :null=>false
    t.integer  "day"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  :default=>"", :null=>false, :index=>{:name=>"index_users_on_email", :unique=>true, :using=>:btree}
    t.string   "encrypted_password",     :default=>"", :null=>false
    t.string   "reset_password_token",   :index=>{:name=>"index_users_on_reset_password_token", :unique=>true, :using=>:btree}
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default=>0, :null=>false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",        :default=>0, :null=>false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",             :null=>false
    t.datetime "updated_at",             :null=>false
    t.string   "username",               :index=>{:name=>"index_users_on_username", :unique=>true, :using=>:btree}
    t.string   "contact_num"
    t.string   "cca",                    :null=>false
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", :index=>{:name=>"index_users_roles_on_user_id", :using=>:btree}
    t.integer "role_id", :index=>{:name=>"index_users_roles_on_role_id", :using=>:btree}

    t.index ["user_id", "role_id"], :name=>"index_users_roles_on_user_id_and_role_id", :using=>:btree
  end

  add_foreign_key "bookings", "items"
  add_foreign_key "bookings", "users"
  add_foreign_key "timeslots", "time_ranges"
  add_foreign_key "timeslots", "users", column: "default_user_id"
end
