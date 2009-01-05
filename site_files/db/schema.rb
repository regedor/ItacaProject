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

ActiveRecord::Schema.define(:version => 20090103182623) do

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.text     "biography"
    t.string   "first_work"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "directors", :force => true do |t|
    t.string   "name"
    t.text     "biography"
    t.string   "first_work"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locals", :force => true do |t|
    t.string   "name"
    t.integer  "contry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.integer  "genre_id"
    t.text     "synopsis"
    t.integer  "author_id"
    t.integer  "director_id"
    t.string   "producer"
    t.integer  "production_year"
    t.integer  "release_date"
    t.integer  "local_id"
    t.text     "comments"
    t.text     "production_context"
    t.string   "distributor"
    t.integer  "duration"
    t.string   "format"
    t.integer  "category_id"
    t.integer  "category_id1"
    t.integer  "category_id2"
    t.integer  "category_id3"
    t.integer  "category_id4"
    t.boolean  "free"
    t.string   "rights"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "title"
    t.text     "synopsis"
    t.integer  "author_id"
    t.string   "editor"
    t.integer  "production_year"
    t.integer  "local_id"
    t.text     "comments"
    t.text     "production_context"
    t.string   "distributor"
    t.string   "format"
    t.integer  "category_id"
    t.integer  "category_id1"
    t.integer  "category_id2"
    t.integer  "category_id3"
    t.integer  "category_id4"
    t.boolean  "free"
    t.string   "rights"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prizes", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sound_documents", :force => true do |t|
    t.string   "title"
    t.text     "synopsis"
    t.integer  "author_id"
    t.integer  "director_id"
    t.string   "producer"
    t.integer  "production_year"
    t.integer  "release_date"
    t.integer  "local_id"
    t.text     "comments"
    t.text     "production_context"
    t.string   "distributor"
    t.integer  "duration"
    t.string   "format"
    t.integer  "category_id"
    t.integer  "category_id1"
    t.integer  "category_id2"
    t.integer  "category_id3"
    t.integer  "category_id4"
    t.boolean  "free"
    t.string   "rights"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.integer  "role",                                     :default => 4
    t.string   "phone",                     :limit => 40
    t.string   "sex",                       :limit => 40
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "writen_documents", :force => true do |t|
    t.string   "title"
    t.integer  "document_type_id"
    t.text     "synopsis"
    t.integer  "author_id"
    t.string   "editor"
    t.integer  "production_year"
    t.integer  "local_id"
    t.text     "comments"
    t.text     "production_context"
    t.string   "distributor"
    t.string   "format"
    t.integer  "category_id"
    t.integer  "category_id1"
    t.integer  "category_id2"
    t.integer  "category_id3"
    t.integer  "category_id4"
    t.boolean  "free"
    t.string   "rights"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
