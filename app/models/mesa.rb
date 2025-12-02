class Mesa < ApplicationRecord
  self.table_name = "mesas"
  self.primary_key = "codigo_mesa" if column_names.include?('codigo_mesa')
  
  belongs_to :user, optional: true
  
  has_many :pedidos, foreign_key: :codigo_mesa, dependent: :destroy
  has_many :contas, foreign_key: :codigo_mesa, dependent: :destroy
  
  attribute :ativo, :boolean, default: true
  
  scope :ativas, -> { where(ativo: true) }
  scope :inativas, -> { where(ativo: false) }
  scope :do_usuario, ->(user_id) { where(user_id: user_id) }
  
  validates :numero, presence: true, uniqueness: { scope: :user_id }
  validates :quant_pessoas, presence: true, numericality: { only_integer: true, greater_than: 0 }
  
  before_create :set_codigo_mesa, unless: -> { codigo_mesa.present? }
  
  def pedido_aberto
    pedidos.where(status: 'aberto').first
  end
  
  def criar_pedido_aberto
    pedidos.create(
      status: 'aberto', 
      data_hora: Time.current, 
      codigo_mesa: codigo_mesa
    )
  end
  
  def disponivel?
    ativo? && status == 'Livre'
  end
  
  private
  
  def set_codigo_mesa
    max_codigo = Mesa.maximum(:codigo_mesa) || 0
    self.codigo_mesa = max_codigo + 1
  end
end