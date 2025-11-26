class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :destroy]

  def new
    @product = Produto.new
  end

  def create
    @product = Produto.new(product_params)

    if @product.save
      redirect_to dashboard_produtos_path, notice: "Produto cadastrado!"
    else
      flash.now[:alert] = "Erro ao salvar."
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
  if @product.update(product_params)
    redirect_to dashboard_produtos_path, notice: "Produto atualizado!"
  else
    render :edit
  end
end

  def destroy
  @product.destroy  
  flash[:notice] = "Excluído!"
  redirect_to dashboard_produtos_path 
end


  private

  def set_product
    @product = Produto.find(params[:id])
  end

  def product_params
    params.require(:produto).permit(:nome, :tipo, :valor, :status)
  end
end