class PedidosController < ApplicationController
  layout "dashboard"
  before_action :set_mesa
  before_action :set_pedido, only: [:index, :create]

  def index
    @itens_pedidos = @pedido.itens_pedidos.includes(:produto)
    @produtos = Produto.all
  end

  def create
    produto_id = params[:produto_id]
    quantidade = params[:quantidade] || 1

    if produto_id.blank?
      redirect_to mesa_pedidos_path(@mesa), alert: 'Selecione um produto'
      return
    end

    if @pedido.adicionar_produto(produto_id, quantidade)
      produto = Produto.find(produto_id)
      log_adicao_produto(@mesa, produto, quantidade) 
      
      @mesa.update(status: 'Ocupado') if @mesa.status != 'Ocupado'
      redirect_to mesa_pedidos_path(@mesa), notice: 'Produto adicionado com sucesso!'
    else
      redirect_to mesa_pedidos_path(@mesa), alert: 'Erro ao adicionar produto'
    end
  end

  private

  def set_mesa
    @mesa = Mesa.find(params[:mesa_id])
  end

  def set_pedido
    @pedido = @mesa.pedido_aberto || @mesa.criar_pedido_aberto
  end
end