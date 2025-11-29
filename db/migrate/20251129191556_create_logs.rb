class CreateLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :logs do |t|
      t.string :email
      t.string :acao
      t.text :detalhes
      t.datetime :data_acao

      t.timestamps
    end
  end
end
