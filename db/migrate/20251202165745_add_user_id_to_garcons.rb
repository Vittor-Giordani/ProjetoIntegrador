class AddUserIdToGarcons < ActiveRecord::Migration[7.1]
  def change
    add_column :garcons, :user_id, :integer
  end
end
