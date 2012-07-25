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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120114095655) do

  create_table "pages", :force => true do |t|
    t.text     "title",                               :null => false
    t.text     "body"
    t.text     "style"
    t.text     "meta_description"
    t.text     "meta_keywords"
    t.string   "slug",                                :null => false
    t.integer  "parent_id"
    t.integer  "display_order",    :default => 0,     :null => false
    t.integer  "status",           :default => 1,     :null => false
    t.boolean  "private",          :default => false, :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "pictures", :force => true do |t|
    t.text     "title"
    t.text     "alt_text"
    t.text     "caption"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "md5"
  end

  create_table "posts", :force => true do |t|
    t.text     "title",                               :null => false
    t.text     "body"
    t.text     "style"
    t.text     "meta_description"
    t.text     "meta_keywords"
    t.string   "slug",                                :null => false
    t.integer  "user_id",                             :null => false
    t.integer  "status",           :default => 1,     :null => false
    t.boolean  "private",          :default => false, :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",          :null => false
    t.string   "encrypted_password",     :default => "",          :null => false
    t.string   "first_name",             :default => "",          :null => false
    t.string   "last_name",              :default => "",          :null => false
    t.string   "phone_number"
    t.string   "role",                   :default => "read_only", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,           :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "users", ["created_at"], :name => "index_users_on_created_at"
  add_index "users", ["current_sign_in_ip"], :name => "index_users_on_current_sign_in_ip"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["last_sign_in_ip"], :name => "index_users_on_last_sign_in_ip"
  add_index "users", ["phone_number"], :name => "index_users_on_phone_number"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["role"], :name => "index_users_on_role"
  add_index "users", ["sign_in_count"], :name => "index_users_on_sign_in_count"
  add_index "users", ["updated_at"], :name => "index_users_on_updated_at"

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
