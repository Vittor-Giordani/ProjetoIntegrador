class AddAtivoToMesas < ActiveRecord::Migration[7.1]
  def change
    add_column :mesas, :ativo, :boolean
  end
end
