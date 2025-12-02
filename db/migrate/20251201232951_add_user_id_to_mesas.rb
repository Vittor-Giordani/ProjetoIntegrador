class AddUserIdToMesas < ActiveRecord::Migration[7.1]
  def change
    add_column :mesas, :user_id, :integer
  end
end
