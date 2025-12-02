class Garcon < ApplicationRecord
  self.table_name = "garcons"
  self.primary_key = "codigo_garcom"
  
  belongs_to :user, optional: false
  
  has_many :pedidos, foreign_key: :codigo_garcom, dependent: :nullify
  
  validates :nome, presence: true
  validates :nome, uniqueness: { scope: :user_id }
  
  scope :do_usuario, ->(user_id) { where(user_id: user_id) }
end