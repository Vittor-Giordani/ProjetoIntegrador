class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  
  has_many :produtos, dependent: :destroy
  has_many :mesas, dependent: :destroy
  has_many :pedidos, through: :mesas
  has_many :contas, through: :mesas
  
  # Adicione esta linha se não existir
  has_many :products, class_name: 'Produto', dependent: :destroy
end