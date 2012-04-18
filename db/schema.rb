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

ActiveRecord::Schema.define(:version => 20120418104653) do

  create_table "items", :force => true do |t|
    t.string    "name"
    t.string    "description"
    t.integer   "merchant_id"
    t.integer   "buyer_id"
    t.timestamp "created_at",         :null => false
    t.timestamp "updated_at",         :null => false
    t.string    "photo_file_name"
    t.string    "photo_content_type"
    t.integer   "photo_file_size"
    t.timestamp "photo_updated_at"
    t.integer   "transaction_id"
    t.integer   "purchase_price"
    t.string    "currency"
  end

  create_table "merchants", :force => true do |t|
    t.string    "email",                  :default => "", :null => false
    t.string    "encrypted_password",     :default => "", :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",          :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at",                             :null => false
    t.timestamp "updated_at",                             :null => false
    t.string    "name"
    t.decimal   "balance"
  end

  add_index "merchants", ["email"], :name => "index_merchants_on_email", :unique => true
  add_index "merchants", ["reset_password_token"], :name => "index_merchants_on_reset_password_token", :unique => true

  create_table "price_points", :force => true do |t|
    t.integer   "price_cents"
    t.string    "currency"
    t.integer   "item_id"
    t.string    "name"
    t.timestamp "created_at",  :null => false
    t.timestamp "updated_at",  :null => false
  end

  create_table "transactions", :force => true do |t|
    t.string    "sender_email"
    t.string    "recipient_email"
    t.boolean   "complete"
    t.string    "description"
    t.timestamp "created_at",      :null => false
    t.timestamp "updated_at",      :null => false
    t.integer   "sender_id"
    t.integer   "recipient_id"
    t.integer   "amount"
    t.string    "currency"
  end

  add_index "transactions", ["recipient_email"], :name => "index_transactions_on_recipient_email"
  add_index "transactions", ["sender_email"], :name => "index_transactions_on_sender_email"

  create_table "users", :force => true do |t|
    t.string    "email",                  :default => "",    :null => false
    t.string    "encrypted_password",     :default => "",    :null => false
    t.string    "name",                   :default => "",    :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",          :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at",                                :null => false
    t.timestamp "updated_at",                                :null => false
    t.string    "avatar_file_name"
    t.string    "avatar_content_type"
    t.integer   "avatar_file_size"
    t.timestamp "avatar_updated_at"
    t.integer   "balance"
    t.string    "currency"
    t.string    "address"
    t.float     "latitude"
    t.float     "longitude"
    t.boolean   "is_merchant",            :default => false
    t.string    "description"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
