class ItensPedidosController < ApplicationController
  def create
    @item_pedido = ItemPedido.new(item_pedido_params)
    
    produto = Produto.do_usuario(current_user.id).find_by(codigo_produto: params[:item_pedido][:codigo_produto])
    
    if produto
      @item_pedido.valor_un = produto.valor
      
      if @item_pedido.save
        redirect_to mesa_pedidos_path(Pedido.find(@item_pedido.codigo_pedido).mesa), 
                    notice: "Produto adicionado ao pedido!"
      else
        redirect_to mesa_pedidos_path(Pedido.find(@item_pedido.codigo_pedido).mesa), 
                    alert: "Erro ao adicionar produto: #{@item_pedido.errors.full_messages.join(', ')}"
      end
    else
      redirect_to mesas_path, alert: "Produto não encontrado."
    end
  end
  
  def destroy
    @item_pedido = ItemPedido.find(params[:id])
    
    pedido = @item_pedido.pedido
    mesa = pedido.mesa
    unless mesa.user_id == current_user.id
      redirect_to root_path, alert: "Você não tem permissão para remover este item."
      return
    end
    
    @item_pedido.destroy
    redirect_back fallback_location: mesas_path, notice: "Item removido com sucesso!"
  end
  
  private
  
  def item_pedido_params
    params.require(:item_pedido).permit(:codigo_produto, :quantidade, :codigo_pedido)
  end
end