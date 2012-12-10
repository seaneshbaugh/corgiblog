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

ActiveRecord::Schema.define(:version => 20120102062006) do

  create_table "pages", :force => true do |t|
    t.string   "title",            :default => "",   :null => false
    t.string   "slug",             :default => "",   :null => false
    t.text     "body",                               :null => false
    t.text     "style",                              :null => false
    t.text     "meta_description",                   :null => false
    t.text     "meta_keywords",                      :null => false
    t.integer  "order",            :default => 0,    :null => false
    t.boolean  "show_in_menu",     :default => true, :null => false
    t.boolean  "visible",          :default => true, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "pages", ["created_at"], :name => "index_pages_on_created_at"
  add_index "pages", ["order"], :name => "index_pages_on_order"
  add_index "pages", ["show_in_menu"], :name => "index_pages_on_show_in_menu"
  add_index "pages", ["slug"], :name => "index_pages_on_slug"
  add_index "pages", ["title"], :name => "index_pages_on_title"
  add_index "pages", ["updated_at"], :name => "index_pages_on_updated_at"
  add_index "pages", ["visible"], :name => "index_pages_on_visible"

  create_table "pictures", :force => true do |t|
    t.text     "title",                                :null => false
    t.text     "alt_text",                             :null => false
    t.text     "caption",                              :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "image_fingerprint"
    t.integer  "image_original_width",  :default => 1, :null => false
    t.integer  "image_original_height", :default => 1, :null => false
    t.integer  "image_medium_width",    :default => 1, :null => false
    t.integer  "image_medium_height",   :default => 1, :null => false
    t.integer  "image_thumb_width",     :default => 1, :null => false
    t.integer  "image_thumb_height",    :default => 1, :null => false
    t.datetime "image_updated_at"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "pictures", ["created_at"], :name => "index_pictures_on_created_at"
  add_index "pictures", ["image_content_type"], :name => "index_pictures_on_image_content_type"
  add_index "pictures", ["image_file_name"], :name => "index_pictures_on_image_file_name"
  add_index "pictures", ["image_file_size"], :name => "index_pictures_on_image_file_size"
  add_index "pictures", ["image_fingerprint"], :name => "index_pictures_on_image_fingerprint"
  add_index "pictures", ["image_medium_height"], :name => "index_pictures_on_image_medium_height"
  add_index "pictures", ["image_medium_width"], :name => "index_pictures_on_image_medium_width"
  add_index "pictures", ["image_original_height"], :name => "index_pictures_on_image_original_height"
  add_index "pictures", ["image_original_width"], :name => "index_pictures_on_image_original_width"
  add_index "pictures", ["image_thumb_height"], :name => "index_pictures_on_image_thumb_height"
  add_index "pictures", ["image_thumb_width"], :name => "index_pictures_on_image_thumb_width"
  add_index "pictures", ["image_updated_at"], :name => "index_pictures_on_image_updated_at"
  add_index "pictures", ["updated_at"], :name => "index_pictures_on_updated_at"

  create_table "posts", :force => true do |t|
    t.string   "title",            :default => "",   :null => false
    t.string   "slug",             :default => "",   :null => false
    t.text     "body",                               :null => false
    t.text     "style",                              :null => false
    t.text     "meta_description",                   :null => false
    t.text     "meta_keywords",                      :null => false
    t.integer  "user_id",                            :null => false
    t.boolean  "visible",          :default => true, :null => false
    t.string   "tumblr_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "posts", ["created_at"], :name => "index_posts_on_created_at"
  add_index "posts", ["slug"], :name => "index_posts_on_slug", :unique => true
  add_index "posts", ["title"], :name => "index_posts_on_title", :unique => true
  add_index "posts", ["tumblr_id"], :name => "index_posts_on_tumblr_id", :unique => true
  add_index "posts", ["updated_at"], :name => "index_posts_on_updated_at"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"
  add_index "posts", ["visible"], :name => "index_posts_on_visible"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "role",                   :default => "", :null => false
    t.string   "first_name",             :default => "", :null => false
    t.string   "last_name",              :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["created_at"], :name => "index_users_on_created_at"
  add_index "users", ["current_sign_in_at"], :name => "index_users_on_current_sign_in_at"
  add_index "users", ["current_sign_in_ip"], :name => "index_users_on_current_sign_in_ip"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["encrypted_password"], :name => "index_users_on_encrypted_password"
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["last_sign_in_at"], :name => "index_users_on_last_sign_in_at"
  add_index "users", ["last_sign_in_ip"], :name => "index_users_on_last_sign_in_ip"
  add_index "users", ["remember_created_at"], :name => "index_users_on_remember_created_at"
  add_index "users", ["reset_password_sent_at"], :name => "index_users_on_reset_password_sent_at"
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
