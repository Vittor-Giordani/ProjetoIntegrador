class ItemPedido < ApplicationRecord
  self.table_name = "itens_pedidos"
  
  belongs_to :pedido, foreign_key: :codigo_pedido
  belongs_to :produto, foreign_key: :codigo_produto
  
  def subtotal
    quantidade * valor_un
  end
end