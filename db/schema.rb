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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120519054557) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "db_name"
    t.text     "address"
    t.string   "contact_number"
    t.integer  "no_of_employees"
    t.string   "stock_symbol"
    t.text     "description"
    t.string   "business_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name",                      :limit => 25, :null => false
    t.string   "last_name",                       :limit => 25, :null => false
    t.integer  "role",                                          :null => false
    t.string   "username",                                      :null => false
    t.string   "email",                                         :null => false
    t.string   "crypted_password",                              :null => false
    t.string   "salt"
    t.integer  "company_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

end
