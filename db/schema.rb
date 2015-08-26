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

ActiveRecord::Schema.define(version: 20150825194218) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pages", force: :cascade do |t|
    t.string   "title",            limit: 510, default: "", null: false
    t.string   "slug",             limit: 510, default: "", null: false
    t.text     "body",                                      null: false
    t.text     "style",                                     null: false
    t.text     "meta_description",                          null: false
    t.text     "meta_keywords",                             null: false
    t.integer  "order",                        default: 0,  null: false
    t.integer  "show_in_menu",                 default: 1,  null: false
    t.integer  "visible",                      default: 1,  null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.text     "title",                                         null: false
    t.text     "alt_text",                                      null: false
    t.text     "caption",                                       null: false
    t.string   "image_file_name",       limit: 510
    t.string   "image_content_type",    limit: 510
    t.integer  "image_file_size"
    t.string   "image_fingerprint",     limit: 510
    t.integer  "image_original_width",              default: 1, null: false
    t.integer  "image_original_height",             default: 1, null: false
    t.integer  "image_medium_width",                default: 1, null: false
    t.integer  "image_medium_height",               default: 1, null: false
    t.integer  "image_thumb_width",                 default: 1, null: false
    t.integer  "image_thumb_height",                default: 1, null: false
    t.datetime "image_updated_at"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title",            limit: 510, default: "", null: false
    t.string   "slug",             limit: 510, default: "", null: false
    t.text     "body",                                      null: false
    t.text     "style",                                     null: false
    t.text     "meta_description",                          null: false
    t.text     "meta_keywords",                             null: false
    t.integer  "user_id",                                   null: false
    t.integer  "visible",                      default: 1,  null: false
    t.string   "tumblr_id",        limit: 510
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "posts", ["slug"], name: "posts_slug_key", unique: true, using: :btree
  add_index "posts", ["title"], name: "posts_title_key", unique: true, using: :btree
  add_index "posts", ["tumblr_id"], name: "posts_tumblr_id_key", unique: true, using: :btree

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
    t.string   "email",                  limit: 510, default: "", null: false
    t.string   "encrypted_password",     limit: 510, default: "", null: false
    t.string   "role",                   limit: 510, default: "", null: false
    t.string   "first_name",             limit: 510, default: "", null: false
    t.string   "last_name",              limit: 510, default: "", null: false
    t.string   "reset_password_token",   limit: 510
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 510
    t.string   "last_sign_in_ip",        limit: 510
    t.string   "authentication_token",   limit: 510
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["authentication_token"], name: "users_authentication_token_key", unique: true, using: :btree
  add_index "users", ["email"], name: "users_email_key", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "users_reset_password_token_key", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 510, null: false
    t.integer  "item_id",                null: false
    t.string   "event",      limit: 510, null: false
    t.string   "whodunnit",  limit: 510
    t.text     "object"
    t.datetime "created_at"
  end

end
