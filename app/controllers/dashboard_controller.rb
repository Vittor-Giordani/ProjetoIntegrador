class DashboardController < ApplicationController
  layout "dashboard"

  def index 
  end

  def charts 
  end

  def produtos
      @produtos = Produto.order(:codigo_produto)
  end

  def layoutstatic
  end

  def produtos
    @produtos = Produto.all
  end

  def novo_produto
    @produto = Product.new
  end

  def criar_produto
    @produto = Product.new(product_params)
    if @produto.save
      redirect_to produtos_dashboard_path, notice: "Produto criado!"
    else
      render :novo_produto
    end
  end

  def editar_produto
    @produto = Product.find(params[:id])
  end

  def atualizar_produto
    @produto = Product.find(params[:id])
    if @produto.update(product_params)
      redirect_to produtos_dashboard_path, notice: "Produto atualizado!"
    else
      render :editar_produto
    end
  end

  private

  def product_params
    params.require(:product).permit(:nome, :descricao, :preco)
  end

end
