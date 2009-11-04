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

ActiveRecord::Schema.define(:version => 20091104143219) do

  create_table "clinicas", :force => true do |t|
    t.string   "nome"
    t.string   "sigla"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clinicas", ["id"], :name => "index_clinicas_on_id"

  create_table "item_tabelas", :force => true do |t|
    t.integer  "tabela_id"
    t.string   "codigo"
    t.string   "descricao"
    t.boolean  "ativo",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_tabelas", ["id"], :name => "index_item_tabelas_on_id"
  add_index "item_tabelas", ["tabela_id"], :name => "index_item_tabelas_on_tabela_id"

  create_table "precos", :force => true do |t|
    t.integer  "clinica_id"
    t.integer  "item_tabela_id"
    t.decimal  "preco",          :precision => 2, :scale => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "precos", ["clinica_id"], :name => "index_precos_on_clinica_id"
  add_index "precos", ["id"], :name => "index_precos_on_id"

  create_table "tabelas", :force => true do |t|
    t.string   "nome"
    t.boolean  "ativa"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tabelas", ["id"], :name => "index_tabelas_on_id"

  create_table "tipo_usuarios", :force => true do |t|
    t.string   "nome"
    t.string   "descricao"
    t.integer  "nivel"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tipo_usuarios", ["id"], :name => "index_tipo_usuarios_on_id"

  create_table "users", :force => true do |t|
    t.string   "login",                                :null => false
    t.string   "email",                                :null => false
    t.string   "crypted_password",                     :null => false
    t.string   "password_salt",                        :null => false
    t.string   "persistence_token",                    :null => false
    t.integer  "login_count",        :default => 0,    :null => false
    t.integer  "failed_login_count", :default => 0,    :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "tipo_usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clinica_id"
    t.string   "nome"
    t.boolean  "ativo",              :default => true
  end

  add_index "users", ["id"], :name => "index_users_on_id"
  add_index "users", ["tipo_usuario_id"], :name => "index_users_on_tipo_usuario_id"

end
