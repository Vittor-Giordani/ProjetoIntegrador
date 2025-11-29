class ItensPedidosController < ApplicationController
  layout "dashboard"
  before_action :set_item_pedido

  def destroy
    mesa = @item_pedido.pedido.mesa
    produto = @item_pedido.produto
    @item_pedido.destroy
    
    log_remocao_produto(mesa, produto) 
    
    if @item_pedido.pedido.itens_pedidos.empty?
      mesa.update(status: 'Livre')
    end
    
    redirect_to mesa_pedidos_path(mesa), notice: 'Item removido com sucesso!'
  end

  private

  def set_item_pedido
    @item_pedido = ItemPedido.find(params[:id])
  end
end