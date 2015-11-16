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

ActiveRecord::Schema.define(version: 20150921141713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pages", force: :cascade do |t|
    t.string   "title",            default: "",   null: false
    t.string   "slug",             default: "",   null: false
    t.text     "body",             default: "",   null: false
    t.text     "style",            default: "",   null: false
    t.text     "meta_description", default: "",   null: false
    t.text     "meta_keywords",    default: "",   null: false
    t.integer  "order",            default: 0,    null: false
    t.boolean  "show_in_menu",     default: true, null: false
    t.boolean  "visible",          default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["created_at"], name: "index_pages_on_created_at", using: :btree
  add_index "pages", ["order"], name: "index_pages_on_order", using: :btree
  add_index "pages", ["show_in_menu"], name: "index_pages_on_show_in_menu", using: :btree
  add_index "pages", ["slug"], name: "index_pages_on_slug", unique: true, using: :btree
  add_index "pages", ["updated_at"], name: "index_pages_on_updated_at", using: :btree
  add_index "pages", ["visible"], name: "index_pages_on_visible", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.text     "title",                 default: "", null: false
    t.text     "alt_text",              default: "", null: false
    t.text     "caption",               default: "", null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "image_fingerprint"
    t.integer  "image_original_width",  default: 1,  null: false
    t.integer  "image_original_height", default: 1,  null: false
    t.integer  "image_medium_width",    default: 1,  null: false
    t.integer  "image_medium_height",   default: 1,  null: false
    t.integer  "image_small_width",     default: 1,  null: false
    t.integer  "image_small_height",    default: 1,  null: false
    t.integer  "image_thumb_width",     default: 1,  null: false
    t.integer  "image_thumb_height",    default: 1,  null: false
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pictures", ["created_at"], name: "index_pictures_on_created_at", using: :btree
  add_index "pictures", ["image_content_type"], name: "index_pictures_on_image_content_type", using: :btree
  add_index "pictures", ["image_file_name"], name: "index_pictures_on_image_file_name", using: :btree
  add_index "pictures", ["image_fingerprint"], name: "index_pictures_on_image_fingerprint", using: :btree
  add_index "pictures", ["image_updated_at"], name: "index_pictures_on_image_updated_at", using: :btree
  add_index "pictures", ["updated_at"], name: "index_pictures_on_updated_at", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title",            default: "",    null: false
    t.string   "slug",             default: "",    null: false
    t.text     "body",             default: "",    null: false
    t.text     "style",            default: "",    null: false
    t.text     "meta_description", default: "",    null: false
    t.text     "meta_keywords",    default: "",    null: false
    t.integer  "user_id",                          null: false
    t.boolean  "visible",          default: true,  null: false
    t.boolean  "sticky",           default: false, null: false
    t.string   "tumblr_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["created_at"], name: "index_posts_on_created_at", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree
  add_index "posts", ["sticky"], name: "index_posts_on_sticky", using: :btree
  add_index "posts", ["updated_at"], name: "index_posts_on_updated_at", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree
  add_index "posts", ["visible"], name: "index_posts_on_visible", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "role",                   default: "", null: false
    t.string   "first_name",             default: "", null: false
    t.string   "last_name",              default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["created_at"], name: "index_users_on_created_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["encrypted_password"], name: "index_users_on_encrypted_password", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role"], name: "index_users_on_role", using: :btree
  add_index "users", ["updated_at"], name: "index_users_on_updated_at", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
