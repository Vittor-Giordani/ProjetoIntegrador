class DashboardController < ApplicationController
  layout "dashboard"

  def index 
  end

  def charts 
  end

  def produtos
    redirect_to products_path
  end

  def layoutstatic
  end

end