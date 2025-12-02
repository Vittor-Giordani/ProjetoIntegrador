class ApplicationController < ActionController::Base
  include Loggable
  
  before_action :set_usuario_logado

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user
  
  # Filtra recursos por usuário
  def recursos_do_usuario(model_class)
    if current_user
      model_class.do_usuario(current_user.id)
    else
      model_class.none
    end
  end

  private

  def set_usuario_logado
    @usuario_logado = User.find_by(id: session[:user_id])
  end
end