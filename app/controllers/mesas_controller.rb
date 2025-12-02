class MesasController < ApplicationController
  layout "dashboard"
  
  def index
    @mesas = Mesa.do_usuario(current_user.id).order(:numero)
    
    @mesas_ativas = @mesas.where(ativo: true)
    @mesas_inativas = @mesas.where(ativo: false)
  end
  
  def new
    @mesa = Mesa.new
    @statuses = [
      ['Livre', 'livre'],
      ['Ocupada', 'ocupada'],
      ['Reservada', 'reservada']
    ]
  end
  
  def create
    @mesa = Mesa.new(mesa_params)
    @mesa.user_id = current_user.id
    
    if @mesa.save
      redirect_to mesas_path, notice: "Mesa cadastrada com sucesso!"
    else
      @statuses = [
        ['Livre', 'livre'],
        ['Ocupada', 'ocupada'],
        ['Reservada', 'reservada']
      ]
      render :new
    end
  end
  
  def edit
    @mesa = Mesa.find(params[:id])
    verificar_permissao(@mesa)
  end
  
  def update
    @mesa = Mesa.find(params[:id])
    verificar_permissao(@mesa)
    
    if @mesa.update(mesa_params)
      redirect_to mesas_path, notice: "Mesa atualizada com sucesso!"
    else
      render :edit
    end
  end
  
  def fechar_conta
  @mesa = Mesa.find(params[:id])
  
  begin
    ActiveRecord::Base.transaction do
      @mesa.pedidos.where(status: 'aberto').update_all(status: 'fechado')
      
      @mesa.update!(status: 'livre')
    end
    
    flash[:success] = "Conta fechada com sucesso! Mesa #{@mesa.numero} está agora livre."
    redirect_to mesas_path
  rescue => e
    flash[:error] = "Erro ao fechar conta: #{e.message}"
    redirect_to mesa_path(@mesa, tab: 'fechar-conta')
  end
end
  
  def reativar
    @mesa = Mesa.find(params[:id])
    verificar_permissao(@mesa)
    
    @mesa.update(ativo: !@mesa.ativo)
    
    if @mesa.ativo
      redirect_to mesas_path, notice: "Mesa reativada com sucesso!"
    else
      redirect_to mesas_path, notice: "Mesa desativada com sucesso!"
    end
  end
  
  private
  
  def mesa_params
    params.require(:mesa).permit(:numero, :quant_pessoas, :status, :ativo)
  end
  
  def verificar_permissao(mesa)
    unless mesa.user_id == current_user.id
      redirect_to mesas_path, alert: "Você não tem permissão para acessar esta mesa."
    end
  end
end