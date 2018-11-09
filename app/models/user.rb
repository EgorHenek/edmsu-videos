class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist
  has_many :channels
  validates :name, uniqueness: true, presence: true, length: { in: 3...16 }, format: {with: /\A[a-zA-Z0-9][a-zA-Z0-9\s_-]{2,15}\z/, message: 'Имя должно начинаться с латинского символа или цифры и может состоять только из латинских символов, цифр, пробела, знаков подчёркивания и дефиса' }
end
