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

ActiveRecord::Schema.define(:version => 20100917160736) do

  create_table "file_versions", :force => true do |t|
    t.integer  "file_id",                     :null => false
    t.integer  "uploader_id"
    t.string   "content_type",                :null => false
    t.integer  "size",                        :null => false
    t.integer  "version",      :default => 1, :null => false
    t.datetime "created_at"
  end

  add_index "file_versions", ["file_id", "version"], :name => "index_file_versions_on_file_id_and_version", :unique => true

  create_table "group_permissions", :force => true do |t|
    t.integer "user_id",                     :null => false
    t.integer "group_id",                    :null => false
    t.boolean "can_view", :default => false, :null => false
    t.boolean "can_edit", :default => false, :null => false
  end

  add_index "group_permissions", ["user_id", "group_id"], :name => "index_group_permissions_on_user_id_and_group_id", :unique => true

  create_table "group_permissions_histories", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "editor_id",  :null => false
    t.integer  "group_id",   :null => false
    t.integer  "role"
    t.integer  "action"
    t.datetime "created_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.string  "name",                         :null => false
    t.boolean "usergroup", :default => false, :null => false
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "page_part_locks", :force => true do |t|
    t.integer  "part_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_part_revisions", :force => true do |t|
    t.integer  "part_id",                                :null => false
    t.integer  "author_id",                              :null => false
    t.datetime "created_at",                             :null => false
    t.text     "body",                                   :null => false
    t.text     "body_without_markup",                    :null => false
    t.boolean  "was_deleted",         :default => false, :null => false
    t.string   "summary"
    t.integer  "number",                                 :null => false
  end

  add_index "page_part_revisions", ["part_id", "number"], :name => "index_page_part_revisions_on_part_id_and_number", :unique => true
  add_index "page_part_revisions", ["part_id"], :name => "index_page_part_revisions_on_page_part_id"

  create_table "page_parts", :force => true do |t|
    t.string  "name",                :null => false
    t.integer "page_id",             :null => false
    t.integer "current_revision_id", :null => false
  end

  add_index "page_parts", ["page_id", "name"], :name => "index_page_parts_on_page_id_and_name"

  create_table "page_permissions", :force => true do |t|
    t.integer "page_id",                       :null => false
    t.integer "group_id",                      :null => false
    t.boolean "can_view",   :default => false, :null => false
    t.boolean "can_edit",   :default => false, :null => false
    t.boolean "can_manage", :default => false, :null => false
  end

  add_index "page_permissions", ["page_id"], :name => "index_page_permissions_on_page_id"

  create_table "page_permissions_histories", :force => true do |t|
    t.integer  "page_id",    :null => false
    t.integer  "user_id",    :null => false
    t.integer  "group_id",   :null => false
    t.integer  "role"
    t.integer  "action"
    t.datetime "created_at", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string  "title",     :null => false
    t.string  "sid"
    t.integer "parent_id"
    t.integer "lft",       :null => false
    t.integer "rgt",       :null => false
    t.string  "layout"
    t.integer "ordering"
  end

  add_index "pages", ["lft", "rgt"], :name => "index_pages_on_lft_and_rgt"
  add_index "pages", ["parent_id", "sid"], :name => "index_pages_on_parent_id_and_sid"

  create_table "subscriptions", :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "page_id", :null => false
  end

  add_index "subscriptions", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "uploaded_files", :force => true do |t|
    t.string  "filename"
    t.integer "page_id"
    t.integer "current_version_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username",                                             :null => false
    t.string   "name",                                                 :null => false
    t.string   "token",                :limit => 32,                   :null => false
    t.string   "prefered_locale"
    t.datetime "last_dashboard_visit"
    t.boolean  "active",                             :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password"
    t.string   "salt"
    t.integer  "fb_id"
    t.string   "email_hash"
  end

  add_index "users", ["token"], :name => "index_users_on_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
