class MesasController < ApplicationController
  layout "dashboard"
  before_action :set_mesa, only: [:edit, :update, :destroy, :fechar_conta, :reativar]
  before_action :set_statuses, only: [:new, :edit]

  def index
    if params[:inativas]
      @mesas = Mesa.inativas
    else
      @mesas = Mesa.ativas
    end
  end

  def new
    @mesa = Mesa.new
    @mesa.ativo = true 
  end

  def create
    @mesa = Mesa.new(mesa_params)
    if @mesa.save
      log_criacao(@mesa) 
      redirect_to mesas_path, notice: "Mesa cadastrada!"
    else
      set_statuses
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @mesa.update(mesa_params)
      log_edicao(@mesa)  
      redirect_to mesas_path, notice: "Mesa atualizada!"
    else
      set_statuses
      render :edit
    end
  end

  def destroy
    if @mesa.update(ativo: false)
      log_exclusao(@mesa) 
      redirect_to mesas_path, notice: "Mesa #{@mesa.numero} inativada com sucesso!"
    else
      redirect_to mesas_path, alert: "Erro ao inativar mesa: #{@mesa.errors.full_messages.join(', ')}"
    end
  end

  def reativar
    if @mesa.update(ativo: true)
      log_reativacao(@mesa)  # ✅ ADICIONAR LOG (novo método)
      redirect_to mesas_path, notice: "Mesa #{@mesa.numero} reativada com sucesso!"
    else
      redirect_to mesas_path(inativas: true), alert: "Erro ao reativar mesa."
    end
  end

  def fechar_conta
    if request.get?
      @pedido = @mesa.pedido_aberto
      unless @pedido && @pedido.itens_pedidos.any?
        redirect_to mesas_path, alert: "Não há pedidos abertos para esta mesa"
        return
      end
      render :fechar_conta
    else

      @pedido = @mesa.pedido_aberto
      if @pedido && @pedido.itens_pedidos.any?
        caixa = Caixa.first
        if caixa.nil?
          caixa = Caixa.create!(
            nome: "Caixa Automático",
            login: "auto",
            senha: "auto123"
          )
        end

        conta = Conta.create(
          total: @pedido.total,
          status: 'fechada',
          data_hora_final: Time.current,
          codigo_mesa: @mesa.codigo_mesa,
          codigo_caixa: caixa.codigo_caixa,
          forma_pagamento: params[:forma_pagamento]
        )
        
        if conta.persisted?
          @pedido.update(status: 'fechado')
          @mesa.update(status: 'Livre')
          log_fechamento_conta(@mesa, conta.total)  # ✅ ADICIONAR LOG
          redirect_to mesas_path, notice: "Conta fechada com sucesso! Total: R$ #{sprintf('%.2f', conta.total)} - Forma de pagamento: #{conta.forma_pagamento}"
        else
          redirect_to fechar_conta_mesa_path(@mesa), alert: "Erro ao fechar conta: #{conta.errors.full_messages.join(', ')}"
        end
      else
        redirect_to mesas_path, alert: "Não há pedidos abertos para esta mesa"
      end
    end
  end

  private

  def set_mesa
    @mesa = Mesa.find(params[:id])
  end

  def set_statuses
    @statuses = ['Livre', 'Reservado', 'Ocupado']
  end

  def mesa_params
    params.require(:mesa).permit(:codigo_mesa, :numero, :status, :quant_pessoas, :ativo)
  end
end