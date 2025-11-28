class Caixa < ApplicationRecord
  self.table_name = "caixas"
  
  has_many :contas, foreign_key: :codigo_caixa
end