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

ActiveRecord::Schema.define(:version => 20111006184803) do

  create_table "accountings", :force => true do |t|
    t.string   "description"
    t.integer  "amount"
    t.datetime "valuta"
    t.integer  "project_id",                              :null => false
    t.boolean  "sent"
    t.boolean  "payed"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "positive",              :default => true, :null => false
    t.datetime "deleted_at"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  add_index "accountings", ["project_id"], :name => "index_accountings_on_project_id"

  create_table "entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "task_id"
    t.string   "description"
    t.time     "start"
    t.time     "end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "day"
    t.boolean  "billable"
    t.integer  "duration"
    t.datetime "deleted_at"
  end

  create_table "milestone_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "milestones", :force => true do |t|
    t.integer  "project_id",                           :null => false
    t.integer  "milestone_type_id",                    :null => false
    t.boolean  "reached",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.datetime "start"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "shortname"
    t.string   "description"
    t.date     "start"
    t.date     "end"
    t.boolean  "inactive"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_state_id"
    t.decimal  "probability",      :default => 0.0
    t.integer  "wage",             :default => 90,   :null => false
    t.integer  "rpl"
    t.datetime "deleted_at"
    t.boolean  "external",         :default => true
  end

  create_table "responsibilities", :force => true do |t|
    t.integer  "responsibility_type_id"
    t.integer  "project_id"
    t.integer  "user_id"
    t.boolean  "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "responsibility_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "required"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.integer  "estimate"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "inactive"
    t.datetime "deleted_at"
  end

  add_index "tasks", ["project_id"], :name => "index_tasks_on_project_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.boolean  "admin",                                 :default => false
    t.datetime "deleted_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
