class SessionsController < ApplicationController
  def new
  end

  def create
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect_to dashboard_index_path
  else
    flash[:alert] = "Email ou senha inválidos"
    render :new
  end
end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logout realizado com sucesso!"
  end
end
