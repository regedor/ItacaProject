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

ActiveRecord::Schema.define(:version => 20090208162224) do

  create_table "author_photos", :force => true do |t|
    t.integer  "author_id"
    t.integer  "photo_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.text     "biography"
    t.string   "first_work"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "user_creator_id"
    t.integer  "user_updator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "name",            :limit => 32
    t.string   "code",            :limit => 3
    t.integer  "user_creator_id"
    t.integer  "user_updator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "directors", :force => true do |t|
    t.string   "name"
    t.text     "biography"
    t.string   "first_work"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_types", :force => true do |t|
    t.string   "name"
    t.integer  "user_creator_id"
    t.integer  "user_updator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.integer  "user_creator_id"
    t.integer  "user_updator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "local_locals", :force => true do |t|
    t.integer  "local_id"
    t.integer  "local2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locals", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movie_locals", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "local_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movie_movies", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "movie2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movie_photos", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movie_prizes", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "prize_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movie_sound_documents", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "sound_document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movie_writen_documents", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "writen_document_id"
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
    t.text     "main_event"
    t.text     "cultural_context"
    t.text     "image_sound"
    t.text     "ccdc"
    t.text     "reading"
    t.text     "exploration"
    t.text     "analisis"
    t.text     "proposals"
    t.text     "production_context"
    t.text     "comments"
    t.string   "distributor"
    t.integer  "duration"
    t.string   "format"
    t.integer  "category_id"
    t.integer  "subcategory_1_id"
    t.integer  "subcategory_2_id"
    t.integer  "subcategory_3_id"
    t.integer  "subcategory_4_id"
    t.boolean  "free"
    t.string   "rights"
    t.string   "youtube_link"
    t.integer  "user_id"
    t.integer  "status",             :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "music_genres", :force => true do |t|
    t.string   "name"
    t.integer  "user_creator_id"
    t.integer  "user_updator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_locals", :force => true do |t|
    t.integer  "photo_id"
    t.integer  "local_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_photos", :force => true do |t|
    t.integer  "photo_id"
    t.integer  "photo2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_prizes", :force => true do |t|
    t.integer  "photo_id"
    t.integer  "prize_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "title"
    t.text     "synopsis"
    t.integer  "author_id"
    t.string   "editor"
    t.integer  "production_year"
    t.text     "comments"
    t.text     "production_context"
    t.string   "distributor"
    t.string   "format"
    t.integer  "category_id"
    t.integer  "subcategory_1_id"
    t.integer  "subcategory_2_id"
    t.integer  "subcategory_3_id"
    t.integer  "subcategory_4_id"
    t.boolean  "free"
    t.string   "rights"
    t.string   "filename"
    t.string   "version_name"
    t.string   "content_type"
    t.integer  "file_size"
    t.integer  "base_version_id"
    t.integer  "photo_owner_id"
    t.string   "photo_owner_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prize_locals", :force => true do |t|
    t.integer  "prize_id"
    t.integer  "local_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prizes", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sound_document_locals", :force => true do |t|
    t.integer  "sound_document_id"
    t.integer  "local_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sound_document_photos", :force => true do |t|
    t.integer  "sound_document_id"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sound_document_prizes", :force => true do |t|
    t.integer  "sound_document_id"
    t.integer  "prize_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sound_document_sound_documents", :force => true do |t|
    t.integer  "sound_document_id"
    t.integer  "sound_document2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sound_document_writen_documents", :force => true do |t|
    t.integer  "sound_document_id"
    t.integer  "writen_document_id"
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
    t.text     "comments"
    t.text     "production_context"
    t.string   "distributor"
    t.integer  "duration"
    t.string   "format"
    t.integer  "category_id"
    t.integer  "subcategory_1_id"
    t.integer  "subcategory_2_id"
    t.integer  "subcategory_3_id"
    t.integer  "subcategory_4_id"
    t.boolean  "free"
    t.string   "rights"
    t.integer  "music_genre_id"
    t.string   "youtube_link"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subcategories", :force => true do |t|
    t.string   "name"
    t.string   "description"
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

  create_table "writen_document_locals", :force => true do |t|
    t.integer  "writen_document_id"
    t.integer  "local_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "writen_document_photos", :force => true do |t|
    t.integer  "writen_document_id"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "writen_document_prizes", :force => true do |t|
    t.integer  "writen_document_id"
    t.integer  "prize_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "writen_document_writen_documents", :force => true do |t|
    t.integer  "writen_document_id"
    t.integer  "writen_document2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "writen_documents", :force => true do |t|
    t.string   "title"
    t.integer  "document_type_id"
    t.text     "synopsis"
    t.integer  "author_id"
    t.string   "editor"
    t.integer  "edition_year"
    t.integer  "local_id"
    t.text     "comments"
    t.text     "production_context"
    t.string   "distributor"
    t.string   "format"
    t.integer  "category_id"
    t.integer  "subcategory_1_id"
    t.integer  "subcategory_2_id"
    t.integer  "subcategory_3_id"
    t.integer  "subcategory_4_id"
    t.boolean  "free"
    t.string   "rights"
    t.string   "filename"
    t.string   "version_name"
    t.string   "content_type"
    t.integer  "file_size"
    t.integer  "base_version_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pdf_owner_id"
    t.string   "pdf_owner_type"
    t.integer  "user_id"
  end

end
