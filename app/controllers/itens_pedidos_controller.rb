class ItensPedidosController < ApplicationController
  layout "dashboard"
  before_action :set_item_pedido

  def destroy
    mesa = @item_pedido.pedido.mesa
    @item_pedido.destroy
    
    # Se não há mais itens no pedido, volta o status para "Livre"
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