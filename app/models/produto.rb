class Produto < ApplicationRecord
  self.table_name = "produtos"
  
  has_many :itens_pedidos, foreign_key: :codigo_produto, class_name: 'ItemPedido'
  has_many :pedidos, through: :itens_pedidos
end