class ProductsController < ApplicationController
  layout "dashboard"
  before_action :set_product, only: [:edit, :update, :destroy]
  before_action :verificar_permissao, only: [:edit, :update, :destroy]
  before_action :carregar_dados_para_formulario, only: [:new, :edit]

  def index
    @products = Produto.do_usuario(current_user.id).order(:nome)
  end

  def new
    @product = Produto.new
  end

  def edit
  end

  def create
    @product = Produto.new(product_params)
    @product.user_id = current_user.id
    
    if @product.save
      redirect_to products_path, notice: "Produto cadastrado com sucesso!"
    else
      carregar_dados_para_formulario
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Produto atualizado com sucesso!"
    else
      carregar_dados_para_formulario
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.item_pedidos.any?
      redirect_to products_path, alert: "Não é possível excluir este produto pois está vinculado a pedidos."
    else
      @product.destroy
      redirect_to products_path, notice: "Produto excluído com sucesso!"
    end
  end

  def show
    redirect_to products_path
  end

  private
  
  def set_product
    @product = Produto.find(params[:id])
  end

  def product_params
    if params[:product]
      params.require(:product).permit(:nome, :tipo, :valor, :status)
    elsif params[:produto]
      params.require(:produto).permit(:nome, :tipo, :valor, :status)
    else
      params.permit(:nome, :tipo, :valor, :status)
    end
  end

  def verificar_permissao
    unless @product.user_id == current_user.id
      redirect_to products_path, alert: "Você não tem permissão para acessar este produto."
    end
  end
  
  def carregar_dados_para_formulario
    @tipos = ['Bebida', 'Comida', 'Sobremesa', 'Acompanhamento', 'Outro']
    @status_options = [['Ativo', 'ativo'], ['Inativo', 'inativo']]
  end
end