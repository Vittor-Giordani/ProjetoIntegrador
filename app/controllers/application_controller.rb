class ApplicationController < ActionController::Base
  include Loggable

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  before_action :set_usuario_logado

  private

  def set_usuario_logado
    @usuario_logado = User.find_by(id: session[:user_id])
  end
end
