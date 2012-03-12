class User < ActiveRecord::Base
  before_create :setBalance
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :avatar
  
  has_many :bills, :class_name => 'Transaction', :foreign_key => :sender_id
  has_many :invoices, :class_name => 'Transaction', :foreign_key => :recipient_id
  
  has_attached_file :avatar, 
                    :storage => :s3,
                    :bucket => 'simpleMoney-dev',
                    :s3_credentials => {
                      :access_key_id => ENV['S3_KEY'],
                      :secret_access_key => ENV['S3_SECRET']
                    },
                    :path => "user/:attachment/:style/:id.:extension",
                    :default_url => "/images/:style/missing.png",
                    :styles => { 
                      :large => "500x500>", 
                      :medium => "150x150>", 
                      :small => "75x75>", 
                      :thumb => "100x100>" 
                    }

  private
    def setBalance
      self.balance = 500.00;
    end
end
