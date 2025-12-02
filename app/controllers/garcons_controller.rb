class GarconsController < ApplicationController
  layout "dashboard"
  before_action :set_garcon, only: [:edit, :update, :destroy]
  before_action :verificar_permissao, only: [:edit, :update, :destroy]
  
  def index
    @garcons = Garcon.do_usuario(current_user.id).order(:nome)
  end
  
  def new
    @garcon = Garcon.new
  end
  
  def create
    @garcon = Garcon.new(garcon_params)
    @garcon.user_id = current_user.id
    
    if @garcon.save
      redirect_to garcons_path, notice: "Garçom cadastrado com sucesso!"
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @garcon.update(garcon_params)
      redirect_to garcons_path, notice: "Garçom atualizado com sucesso!"
    else
      render :edit
    end
  end
  
  def destroy
    if @garcon.pedidos.any?
      redirect_to garcons_path, alert: "Não é possível excluir este garçom pois está vinculado a pedidos."
    else
      @garcon.destroy
      redirect_to garcons_path, notice: "Garçom excluído com sucesso!"
    end
  end
  
  private
  
  def set_garcon
    @garcon = Garcon.find(params[:id])
  end
  
  def garcon_params
    params.require(:garcon).permit(:nome)
  end
  
  def verificar_permissao
    unless @garcon.user_id == current_user.id
      redirect_to garcons_path, alert: "Você não tem permissão para acessar este garçom."
    end
  end
end