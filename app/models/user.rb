class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :balance
  
  has_many :bills, :class_name => 'Transaction', :foreign_key => :sender_id
  has_many :invoices, :class_name => 'Transaction', :foreign_key => :recipient_id
end
