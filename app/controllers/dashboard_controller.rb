class DashboardController < ApplicationController
  layout "dashboard"

  def index 
  end

  def charts 
  end

  def produtos
    # Redirecione para products_path em vez de renderizar uma view própria
    redirect_to products_path
  end

  def layoutstatic
  end

end