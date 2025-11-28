class CreateItemPedidos < ActiveRecord::Migration[7.1]
  def change
    create_table :item_pedidos do |t|
      t.integer :quantidade
      t.float :valor_un
      t.integer :codigo_pedido
      t.integer :codigo_produto

      t.timestamps
    end
  end
end
