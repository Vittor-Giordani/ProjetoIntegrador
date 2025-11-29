class LogsController < ApplicationController
  layout "dashboard"

  def index
    @logs = Log.order(data_acao: :desc).page(params[:page]).per(50)
  end
end