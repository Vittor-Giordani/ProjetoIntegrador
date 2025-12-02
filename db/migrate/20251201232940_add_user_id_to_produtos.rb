class AddUserIdToProdutos < ActiveRecord::Migration[7.1]
  def change
    add_column :produtos, :user_id, :integer
  end
end
