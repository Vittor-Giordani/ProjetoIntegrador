class Log < ApplicationRecord
  def self.registrar(email, acao, detalhes = nil)
    create(
      email: email,
      acao: acao,
      detalhes: detalhes,
      data_acao: Time.current
    )
  end
end