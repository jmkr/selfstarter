class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable #:confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :remember_me, :password_confirmation, :remember_me

  has_many :orders
  #has_many :shipments, through: :orders #doesnt work cause orders has_many shipments
  #create custom association if needed
end
