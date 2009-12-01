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

ActiveRecord::Schema.define(:version => 20091130220959) do

  create_table "bancos", :force => true do |t|
    t.string   "numero"
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cheques", :force => true do |t|
    t.integer  "banco_id"
    t.string   "agencia"
    t.string   "conta_corrente"
    t.string   "numero"
    t.decimal  "valor"
    t.integer  "recebimento_id"
    t.integer  "paciente_id"
    t.integer  "segundo_paciente"
    t.integer  "terceiro_paciente"
    t.decimal  "valor_primeiro_paciente"
    t.decimal  "valor_segundo_paciente"
    t.decimal  "valor_terceiro_paciente"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "bom_para"
    t.integer  "clinica_id"
    t.date     "data_primeira_devolucao"
    t.string   "motivo_primeira_devolucao"
    t.date     "data_lancamento_primeira_devolucao"
    t.date     "data_reapresentacao"
    t.date     "data_segunda_devolucao"
    t.string   "motivo_segunda_devolucao"
    t.date     "data_solucao"
    t.string   "descricao_solucao"
    t.boolean  "reapresentacao"
    t.date     "data_spc"
    t.date     "data_arquivo_morto"
    t.date     "data_entrega_administracao"
    t.date     "data_recebimento_na_administracao"
    t.integer  "pagamento_id"
  end

  add_index "cheques", ["recebimento_id"], :name => "index_cheques_on_recebimento_id"

  create_table "clinicas", :force => true do |t|
    t.string   "nome"
    t.string   "sigla"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clinicas", ["id"], :name => "index_clinicas_on_id"

  create_table "clinicas_dentistas", :id => false, :force => true do |t|
    t.integer "clinica_id"
    t.integer "dentista_id"
  end

  create_table "debitos", :force => true do |t|
    t.integer  "paciente_id"
    t.integer  "tratamento_id"
    t.decimal  "valor"
    t.string   "descricao"
    t.date     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "debitos", ["paciente_id"], :name => "index_debitos_on_paciente_id"

  create_table "dentistas", :force => true do |t|
    t.string   "nome"
    t.string   "telefone"
    t.string   "celular"
    t.boolean  "ativo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cro"
  end

  create_table "formas_recebimentos", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "formas_recebimentos", ["id"], :name => "index_formas_recebimentos_on_id"

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

  create_table "pacientes", :force => true do |t|
    t.string   "nome"
    t.string   "logradouro"
    t.string   "numero",            :limit => 10
    t.string   "complemento",       :limit => 10
    t.string   "telefone",          :limit => 50
    t.string   "celular",           :limit => 50
    t.string   "email",             :limit => 120
    t.integer  "tabela_id"
    t.date     "inicio_tratamento"
    t.date     "nascimento"
    t.string   "bairro",            :limit => 30
    t.string   "cidade",            :limit => 30
    t.string   "uf",                :limit => 2
    t.string   "cep",               :limit => 8
    t.string   "cpf",               :limit => 14
    t.string   "sexo",              :limit => 1
    t.integer  "clinica_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "codigo"
  end

  add_index "pacientes", ["id"], :name => "index_pacientes_on_id"
  add_index "pacientes", ["nome"], :name => "index_pacientes_on_nome"

  create_table "pagamentos", :force => true do |t|
    t.integer  "clinica_id"
    t.integer  "tipo_pagamento_id"
    t.date     "data_de_vencimento"
    t.date     "data_de_pagamento"
    t.decimal  "valor"
    t.decimal  "valor_pago"
    t.string   "observacao"
    t.boolean  "nao_lancar_no_livro_caixa", :default => false
    t.datetime "data_de_exclusao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pagamentos", ["clinica_id"], :name => "index_pagamentos_on_clinica_id"
  add_index "pagamentos", ["id"], :name => "index_pagamentos_on_id"

  create_table "precos", :force => true do |t|
    t.integer  "clinica_id"
    t.integer  "item_tabela_id"
    t.decimal  "preco",          :precision => 6, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "precos", ["clinica_id"], :name => "index_precos_on_clinica_id"
  add_index "precos", ["id"], :name => "index_precos_on_id"

  create_table "recebimentos", :force => true do |t|
    t.integer  "paciente_id"
    t.integer  "clinica_id"
    t.date     "data"
    t.integer  "formas_recebimento_id"
    t.decimal  "valor",                 :precision => 6, :scale => 2
    t.string   "observacao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recebimentos", ["clinica_id"], :name => "index_recebimentos_on_clinica_id"
  add_index "recebimentos", ["paciente_id"], :name => "index_recebimentos_on_paciente_id"

  create_table "tabelas", :force => true do |t|
    t.string   "nome"
    t.boolean  "ativa"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tabelas", ["id"], :name => "index_tabelas_on_id"

  create_table "tipo_pagamentos", :force => true do |t|
    t.integer  "clinica_id"
    t.string   "nome"
    t.integer  "ativo",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tipo_pagamentos", ["clinica_id"], :name => "index_tipo_pagamentos_on_clinica_id"
  add_index "tipo_pagamentos", ["id"], :name => "index_tipo_pagamentos_on_id"

  create_table "tipo_usuarios", :force => true do |t|
    t.string   "nome"
    t.string   "descricao"
    t.integer  "nivel"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tipo_usuarios", ["id"], :name => "index_tipo_usuarios_on_id"

  create_table "tratamentos", :force => true do |t|
    t.integer  "paciente_id"
    t.integer  "item_tabela_id"
    t.integer  "dentista_id"
    t.decimal  "valor",          :precision => 6, :scale => 2
    t.date     "data"
    t.string   "dente"
    t.integer  "orcamento_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tratamentos", ["id"], :name => "index_tratamentos_on_id"
  add_index "tratamentos", ["paciente_id"], :name => "index_tratamentos_on_paciente_id"

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
