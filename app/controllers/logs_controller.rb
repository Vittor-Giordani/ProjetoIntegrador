class LogsController < ApplicationController
  layout "dashboard"

  def index
    @logs = Log.all.order(data_acao: :desc)
    
    if params[:usuario].present?
      @logs = @logs.where("email ILIKE ?", "%#{params[:usuario]}%")
    end
    
    if params[:acao].present?
      @logs = @logs.where("acao ILIKE ?", "%#{params[:acao]}%")
    end
   
    if params[:data_inicio].present?
      begin
        dia, mes, ano = params[:data_inicio].split('/')
        start_date = Date.new(ano.to_i, mes.to_i, dia.to_i).beginning_of_day
        @logs = @logs.where("data_acao >= ?", start_date)
      rescue => e
        flash.now[:alert] = "Data inicial inválida. Use o formato dd/mm/aaaa."
      end
    end
    
    if params[:data_fim].present?
      begin
        dia, mes, ano = params[:data_fim].split('/')
        end_date = Date.new(ano.to_i, mes.to_i, dia.to_i).end_of_day
        @logs = @logs.where("data_acao <= ?", end_date)
      rescue => e
        flash.now[:alert] = "Data final inválida. Use o formato dd/mm/aaaa."
      end
    end
    
    if params[:data_inicio].present? && params[:data_fim].present?
      begin
        dia_inicio, mes_inicio, ano_inicio = params[:data_inicio].split('/')
        dia_fim, mes_fim, ano_fim = params[:data_fim].split('/')
        
        data_inicio_obj = Date.new(ano_inicio.to_i, mes_inicio.to_i, dia_inicio.to_i)
        data_fim_obj = Date.new(ano_fim.to_i, mes_fim.to_i, dia_fim.to_i)
        
        if data_fim_obj < data_inicio_obj
          flash.now[:alert] = "Data final não pode ser anterior à data inicial."
        end
      rescue => e
      end
    end
    
    @logs = @logs.page(params[:page]).per(50)
    
    @total_logs = Log.count
    @logs_hoje = Log.where("DATE(data_acao) = ?", Date.today).count
    @usuarios_unicos = Log.distinct.count(:email)
    @tipos_acao = Log.distinct.count(:acao)
    
    @usuarios_list = Log.distinct.order(:email).pluck(:email)
    @acoes_list = Log.distinct.order(:acao).pluck(:acao)
  end
end