# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "categories", :id => true, :force => true do |t|
    t.string  "name", :limit => 60, :null => false
    t.string  "category_type", :limit => 1,  :null => false
  end

  add_index "categories", ["id"], :name => "categories_pk", :unique => true

  create_table "comments", :id => true, :force => true do |t|
    t.integer "user_id",   :null => false
    t.integer "widget_id", :null => false
    t.text    "message",   :null => false
    t.datetime "created_at"
  end

  add_index "comments", ["id"], :name => "comments_pk", :unique => true
  add_index "comments", ["user_id"], :name => "comments_addedby_user"
  add_index "comments", ["widget_id"], :name => "comments_relatedto_widget"

  create_table "containers", :id => true, :force => true do |t|
    t.integer "widget_id",                                            :null => false
    t.integer "tab_id",                                               :null => false
    t.integer "order",     :limit => 6, :precision => 1, :scale => 0
    t.integer "column",    :limit => 1, :precision => 1, :scale => 0
    t.string  "color",     :limit => 6
  end

  add_index "containers", ["id"], :name => "containers_pk", :unique => true
  add_index "containers", ["tab_id"], :name => "containers_belongto_tabs"
  add_index "containers", ["widget_id"], :name => "containers_hasone_widget"

  create_table "groups", :id => true, :force => true do |t|
    t.string  "name", :limit => 60
    t.integer "user_id", :null => false
  end

  add_index "groups", ["id"], :name => "groups_pk", :unique => true
  add_index "groups", ["user_id"], :name => "group_belongto_user"

  create_table "images", :id => true, :force => true do |t|
    t.string   "data_file_name",    :limit => 60,  :null => false
    t.string   "image_url",          :limit => 200, :null => false
    t.string   "data_content_type", :limit => 10,  :null => false
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
  end

  add_index "images", ["id"], :name => "images_pk", :unique => true

  create_table "ratings", :id => true, :force => true do |t|
    t.integer "widget_id",                                            :null => false
    t.integer "user_id",                                              :null => false
    t.integer "rate",      :limit => 2, :precision => 2, :scale => 0, :null => false
  end

  add_index "ratings", ["id"], :name => "ratings_pk", :unique => true
  add_index "ratings", ["user_id"], :name => "ratings_addedby_user"
  add_index "ratings", ["widget_id"], :name => "ratings_relatedto_widget"

  create_table "requests", :id => true, :force => true do |t|
    t.integer  "theme_id",                  :null => true
    t.integer  "widget_id",                 :null => true
    t.integer  "user_id",                   :null => false
    t.integer  "comment_id",                :null => true
    t.text     "message"
    t.boolean  "approved"
    t.string   "request_type", :limit => 1, :null => false
    t.datetime "created_at"
  end

  add_index "requests", ["comment_id"], :name => "requests_relatedto_comment"
  add_index "requests", ["id"], :name => "requests_pk", :unique => true
  add_index "requests", ["theme_id"], :name => "requests_relatedto_theme"
  add_index "requests", ["user_id"], :name => "requests_addedby_user"
  add_index "requests", ["widget_id"], :name => "requests_relatedto_widget"

  create_table "roles", :id => true, :force => true do |t|
    t.string  "name",        :limit => 60, :null => false
    t.text    "description"
  end

  add_index "roles", ["id"], :name => "roles_pk", :unique => true

  create_table "tabs", :id => true, :force => true do |t|
    t.integer "image_id"
    t.integer "user_id"
    t.string  "session_id"
    # t.integer "theme_id",               :null => true
    t.string  "title",    :limit => 60, :null => false
    t.string  "layout",   :limit => 5, :null => false
  end

  add_index "tabs", ["id"], :name => "tabs_pk", :unique => true
  add_index "tabs", ["image_id"], :name => "tabs_hasone_image"
  # add_index "tabs", ["theme_id"], :name => "tabs_hasone_theme"
  add_index "tabs", ["session_id"]
  add_index "tabs", ["user_id"], :name => "tabs_belongsto_user"

  create_table "tags", :id => true, :force => true do |t|
    t.integer "widget_id",               :null => false
    t.string  "name",      :limit => 60, :null => false
  end

  add_index "tags", ["id"], :name => "tags_pk", :unique => true
  add_index "tags", ["widget_id"], :name => "tags_belongsto_widget"

  create_table "themes", :id => true, :force => true do |t|
    t.integer "user_id",                   :null => false
    t.integer "category_id",               :null => true
    t.integer "image_id"
    t.string  "name",        :limit => 60, :null => false
    t.string  "color",       :limit => 6
    t.string  "font",        :limit => 60
		t.boolean "approved"
    t.boolean "public"
  end

  add_index "themes", ["category_id"], :name => "themes_belongsto_cat"
  add_index "themes", ["id"], :name => "themes_pk", :unique => true
  add_index "themes", ["image_id"], :name => "themes_hasone_image"
  add_index "themes", ["user_id"], :name => "themes_addedby_user"

  create_table "users", :id => true, :force => true do |t|
    t.integer  "role_id",                      :null => false
    t.integer  "theme_id",                     :null => true
    t.string   "username",                     :null => false
    t.string   "email",                        :null => false
    t.string   "crypted_password",             :null => false
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.string   "first_name",    :limit => 20
    t.string   "last_name",     :limit => 20
    t.string   "web_site",      :limit => 150
    t.boolean  "active"
    t.boolean  "banned"
    t.boolean  "logged"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["id"], :name => "users_pk", :unique => true
  add_index "users", ["username"], :unique => true
  add_index "users", ["email"], :unique => true
  add_index "users", ["role_id"], :name => "users_hasone_role"
  add_index "users", ["theme_id"], :name => "users_hasone_theme"

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id", :null => false
    t.integer "user_id",  :null => false
  end

  add_index "groups_users", ["group_id", "user_id"], :name => "users_groups_pk", :unique => true
  add_index "groups_users", ["group_id"], :name => "users_groups_fk"
  add_index "groups_users", ["user_id"], :name => "users_groups2_fk"

  create_table "widgetparams", :id => true, :force => true do |t|
    t.integer "container_id",                :null => false
    t.string  "name",         :limit => 60,  :null => false
    t.string  "value",        :limit => 250, :null => false
  end

  add_index "widgetparams", ["container_id"], :name => "params_belongsto_container"
  add_index "widgetparams", ["id"], :name => "widgetparams_pk", :unique => true

  create_table "widgets", :id => true, :force => true do |t|
    t.integer "category_id",                :null => true
    t.integer "user_id",                    :null => false
    t.integer "image_id"
    t.string  "name",        :limit => 60,  :null => false
    t.string  "description", :limit => 100,  :null => true
    t.string  "url",         :limit => 200, :null => false
    t.boolean "approved"
    t.boolean "public"
    t.text  "preferences"
  end

  add_index "widgets", ["category_id"], :name => "widgets_belongsto_cat"
  add_index "widgets", ["id"], :name => "widgets_pk", :unique => true
  add_index "widgets", ["image_id"], :name => "widgets_hasone_cat"
  add_index "widgets", ["user_id"], :name => "widgets_addedby_user"

  create_table "groups_widgets", :id => false, :force => true do |t|
    t.integer "widget_id", :null => false
    t.integer "group_id",  :null => false
  end

  add_index "groups_widgets", ["group_id"], :name => "widgets_groups2_fk"
  add_index "groups_widgets", ["widget_id", "group_id"], :name => "widgets_groups_pk", :unique => true
  add_index "groups_widgets", ["widget_id"], :name => "widgets_groups_fk"

  add_foreign_key "comments", "users", :name => "fk_comments_comments__users", :dependent => :delete
  add_foreign_key "comments", "widgets", :name => "fk_comments_comments__widgets", :dependent => :delete

  add_foreign_key "containers", "tabs", :name => "fk_containe_container_tabs", :dependent => :delete
  add_foreign_key "containers", "widgets", :name => "fk_containe_container_widgets", :dependent => :delete

  add_foreign_key "ratings", "users", :name => "fk_ratings_ratings_a_users"
  add_foreign_key "ratings", "widgets", :name => "fk_ratings_ratings_r_widgets", :dependent => :delete

  add_foreign_key "requests", "comments", :name => "fk_requests_requests__comments", :dependent => :delete
  add_foreign_key "requests", "themes", :name => "fk_requests_requests__themes", :dependent => :delete
  add_foreign_key "requests", "users", :name => "fk_requests_requests__users", :dependent => :delete
  add_foreign_key "requests", "widgets", :name => "fk_requests_requests__widgets", :dependent => :delete

  add_foreign_key "tabs", "images", :name => "fk_tabs_tabs_haso_images"
  # add_foreign_key "tabs", "themes", :name => "fk_tabs_tabs_haso_themes"
  add_foreign_key "tabs", "users", :name => "fk_tabs_tabs_belo_users", :dependent => :delete

  add_foreign_key "tags", "widgets", :name => "fk_tags_tags_belo_widgets", :dependent => :delete

  add_foreign_key "themes", "categories", :name => "fk_themes_themes_be_categori"
  add_foreign_key "themes", "images", :name => "fk_themes_themes_ha_images"
  add_foreign_key "themes", "users", :name => "fk_themes_themes_ad_users", :dependent => :delete

  add_foreign_key "users", "roles", :name => "fk_users_user_haso_roles"
  add_foreign_key "users", "themes", :name => "fk_users_user_haso_themes"

  add_foreign_key "groups", "users", :name => "fk_group_belongsto_user", :dependent => :delete

  add_foreign_key "groups_users", "groups", :name => "fk_users_gr_users_gro_groups", :dependent => :delete
  add_foreign_key "groups_users", "users", :name => "fk_users_gr_users_gro_users"

  add_foreign_key "widgetparams", "containers", :name => "fk_widgetpa_params_be_containe", :dependent => :delete

  add_foreign_key "widgets", "categories", :name => "fk_widgets_widgets_b_categori"
  add_foreign_key "widgets", "images", :name => "fk_widgets_widgets_h_images"
  add_foreign_key "widgets", "users", :name => "fk_widgets_widgets_a_users", :dependent => :delete

  add_foreign_key "groups_widgets", "groups", :name => "fk_widgets__widgets_g_groups", :dependent => :delete
  add_foreign_key "groups_widgets", "widgets", :name => "fk_widgets__widgets_g_widgets"

end
