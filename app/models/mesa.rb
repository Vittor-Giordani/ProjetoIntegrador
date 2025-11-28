class Mesa < ApplicationRecord
  self.table_name = "mesas"
  
  has_many :pedidos, foreign_key: :codigo_mesa
  has_many :contas, foreign_key: :codigo_mesa
  
  def pedido_aberto
    pedidos.where(status: 'aberto').first
  end
  
  def criar_pedido_aberto
    pedidos.create(status: 'aberto', data_hora: Time.current, codigo_mesa: codigo_mesa)
  end
end