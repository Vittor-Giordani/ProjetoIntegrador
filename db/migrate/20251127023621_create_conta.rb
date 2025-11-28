class CreateConta < ActiveRecord::Migration[7.1]
  def change
    create_table :conta do |t|
      t.float :total
      t.string :status
      t.time :data_hora_inicio
      t.datetime :data_hora_final
      t.integer :codigo_mesa
      t.integer :codigo_caixa

      t.timestamps
    end
  end
end
