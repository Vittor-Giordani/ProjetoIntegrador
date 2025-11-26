class MesasController < ApplicationController
  layout "dashboard"
  before_action :set_mesa, only: [:edit, :update, :destroy]
  before_action :set_statuses, only: [:new, :edit]

  def index
    @mesas = Mesa.all
  end

  def new
    @mesa = Mesa.new
  end

  def create
    @mesa = Mesa.new(mesa_params)
    if @mesa.save
      redirect_to mesas_path, notice: "Mesa cadastrada!"
    else
      set_statuses
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @mesa.update(mesa_params)
      redirect_to mesas_path, notice: "Mesa atualizada!"
    else
      set_statuses
      render :edit
    end
  end

  def destroy
    @mesa.destroy
    redirect_to mesas_path, notice: "Mesa excluída!"
  end

  private

  def set_mesa
    @mesa = Mesa.find(params[:id])
  end

  def set_statuses
    @statuses = ['Livre', 'Reservado', 'Ocupado']
  end

  def mesa_params
    params.require(:mesa).permit(:codigo_mesa, :numero, :status, :quant_pessoas)
  end
end
