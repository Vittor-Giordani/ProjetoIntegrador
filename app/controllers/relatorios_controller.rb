require 'csv'
class RelatoriosController < ApplicationController
  layout "dashboard"  

  def index
    # apenas exibição para gerar os relatórios
  end

  def pedidos
  produtos = Produto.all.order(:nome) 
  csv_data = CSV.generate(headers: true, col_sep: ';', encoding: 'UTF-8') do |csv|
    csv << ["Código Produto", "Nome Produto", "Quantidade Vendida", "Valor Total Recebido (R$)"]
    produtos.each do |prod|
      quantidade = Pedido.where(produto_id: prod.id).sum(:quantidade) rescue 0
      total = prod.valor.to_f * quantidade
      csv << [prod.codigo_produto, prod.nome, quantidade, ("%.2f" % total).gsub('.', ',')]
    end
  end

    respond_to do |format|
      format.csv do
        send_data csv_data, filename: "relatorio_pedidos_#{Date.today}.csv"
      end
    end
  end

  def mesas_pessoas

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["Código Mesa", "Número Mesa", "Quantidade de Pessoas"]

      Mesa.all.each do |mesa|
        csv << [mesa.codigo_mesa, mesa.numero, mesa.quant_pessoas]
      end
    end

    respond_to do |format|
      format.csv do
        send_data csv_data, filename: "relatorio_mesas_pessoas_#{Date.today}.csv"
      end
    end
  end
end
