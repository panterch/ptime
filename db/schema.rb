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

ActiveRecord::Schema.define(:version => 20090122140047) do

  create_table "bills", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.date     "start"
    t.date     "end"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collaborations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "engagements", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", :force => true do |t|
    t.float   "duration"
    t.date    "date"
    t.integer "project_id"
    t.integer "user_id"
    t.string  "description"
    t.integer "task_id"
    t.integer "bill_id"
  end

  create_table "projects", :force => true do |t|
    t.boolean "inactive"
    t.string  "description"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.string  "name"
    t.float   "estimation"
    t.integer "project_id"
    t.integer "position"
  end

  create_table "users", :force => true do |t|
    t.string  "name"
    t.string  "hashed_password"
    t.boolean "inactive"
  end

end
