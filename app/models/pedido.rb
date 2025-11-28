class Pedido < ApplicationRecord
  self.table_name = "pedidos"
  
  belongs_to :mesa, foreign_key: :codigo_mesa
  belongs_to :garcom, foreign_key: :codigo_garcom, optional: true
  has_many :itens_pedidos, foreign_key: :codigo_pedido, dependent: :destroy, class_name: 'ItemPedido'
  has_many :produtos, through: :itens_pedidos
  
  def total
    itens_pedidos.sum { |item| item.quantidade * item.valor_un }
  end
  
  def adicionar_produto(produto_id, quantidade = 1)
    produto = Produto.find(produto_id)
    item = itens_pedidos.find_or_initialize_by(codigo_produto: produto_id)
    
    if item.persisted?
      item.update(quantidade: item.quantidade + quantidade.to_i)
    else
      item.quantidade = quantidade.to_i
      item.valor_un = produto.valor
      item.save
    end
    item
  end
end