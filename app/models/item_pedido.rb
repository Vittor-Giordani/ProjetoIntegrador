class ItemPedido < ApplicationRecord
  self.table_name = "itens_pedidos"
  self.primary_key = "codigo_itens"
  
  belongs_to :pedido, foreign_key: :codigo_pedido, optional: true
  belongs_to :produto, foreign_key: :codigo_produto, optional: true
  
  validates :quantidade, numericality: { greater_than: 0 }
  
  def subtotal
    quantidade * valor_un
  end
end