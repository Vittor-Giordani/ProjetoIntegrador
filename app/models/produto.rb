class Produto < ApplicationRecord
  self.table_name = "produtos"
  self.primary_key = "codigo_produto"
  
  belongs_to :user, optional: true
  
  has_many :item_pedidos, 
           foreign_key: :codigo_produto, 
           class_name: 'ItemPedido',
           dependent: :nullify
  
  validates :nome, presence: true
  validates :valor, numericality: { greater_than: 0 }
  
  scope :do_usuario, ->(user_id) { where(user_id: user_id) }
end