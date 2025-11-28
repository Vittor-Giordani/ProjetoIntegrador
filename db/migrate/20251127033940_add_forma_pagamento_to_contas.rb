class AddFormaPagamentoToContas < ActiveRecord::Migration[7.1]
  def change
    add_column :contas, :forma_pagamento, :string
  end
end
