class Conta < ApplicationRecord
  self.table_name = "contas"
  
  belongs_to :mesa, foreign_key: :codigo_mesa
  belongs_to :caixa, foreign_key: :codigo_caixa, optional: true
  
  before_create :definir_data_inicio
  
  private
  
  def definir_data_inicio
    self.data_hora_inicio ||= Time.current
  end
end