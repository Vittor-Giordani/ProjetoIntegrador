# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_11_29_191556) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "caixas", primary_key: "codigo_caixa", id: :serial, force: :cascade do |t|
    t.string "nome", limit: 100
    t.string "login", limit: 50
    t.string "senha", limit: 100
  end

  create_table "conta", force: :cascade do |t|
    t.float "total"
    t.string "status"
    t.time "data_hora_inicio"
    t.datetime "data_hora_final"
    t.integer "codigo_mesa"
    t.integer "codigo_caixa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contas", primary_key: "codigo_conta", id: :serial, force: :cascade do |t|
    t.float "total"
    t.string "status", limit: 50
    t.time "data_hora_inicio"
    t.datetime "data_hora_final", precision: nil
    t.integer "codigo_mesa", null: false
    t.integer "codigo_caixa", null: false
    t.string "forma_pagamento"
  end

  create_table "garcons", primary_key: "codigo_garcom", id: :serial, force: :cascade do |t|
    t.string "nome", limit: 100
  end

  create_table "item_pedidos", force: :cascade do |t|
    t.integer "quantidade"
    t.float "valor_un"
    t.integer "codigo_pedido"
    t.integer "codigo_produto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "itens_pedidos", primary_key: "codigo_itens", id: :serial, force: :cascade do |t|
    t.integer "quantidade"
    t.float "valor_un"
    t.integer "codigo_pedido", null: false
    t.integer "codigo_produto", null: false
  end

  create_table "logs", force: :cascade do |t|
    t.string "email"
    t.string "acao"
    t.text "detalhes"
    t.datetime "data_acao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mesas", primary_key: "codigo_mesa", id: :serial, force: :cascade do |t|
    t.integer "numero"
    t.string "status", limit: 50
    t.integer "quant_pessoas"
    t.boolean "ativo"
  end

  create_table "pedidos", primary_key: "codigo_pedido", id: :serial, force: :cascade do |t|
    t.datetime "data_hora", precision: nil
    t.string "status", limit: 50
    t.integer "codigo_garcom"
    t.integer "codigo_mesa"
  end

  create_table "produtos", primary_key: "codigo_produto", id: :serial, force: :cascade do |t|
    t.string "nome", limit: 100
    t.string "tipo", limit: 50
    t.float "valor"
    t.string "status", limit: 50
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "contas", "caixas", column: "codigo_caixa", primary_key: "codigo_caixa", name: "contas_codigo_caixa_fkey"
  add_foreign_key "contas", "mesas", column: "codigo_mesa", primary_key: "codigo_mesa", name: "contas_codigo_mesa_fkey"
  add_foreign_key "itens_pedidos", "pedidos", column: "codigo_pedido", primary_key: "codigo_pedido", name: "itens_pedidos_codigo_pedido_fkey"
  add_foreign_key "itens_pedidos", "produtos", column: "codigo_produto", primary_key: "codigo_produto", name: "itens_pedidos_codigo_produto_fkey"
  add_foreign_key "pedidos", "garcons", column: "codigo_garcom", primary_key: "codigo_garcom", name: "pedidos_codigo_garcom_fkey"
  add_foreign_key "pedidos", "mesas", column: "codigo_mesa", primary_key: "codigo_mesa", name: "pedidos_codigo_mesa_fkey"
end
