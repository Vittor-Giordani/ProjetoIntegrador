class Log < ApplicationRecord
  # Registra uma ação no sistema
  def self.registrar(email, acao, detalhes = nil)
    create(
      email: email,
      acao: acao,
      detalhes: detalhes,
      data_acao: Time.current
    )
  end
end