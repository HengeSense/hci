class User < ActiveRecord::Base
  before_create :setBalance
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :avatar, :name, :email, :password, :password_confirmation, :remember_me
  
  has_many :bills, :class_name => 'Transaction', :foreign_key => :sender_id
  has_many :invoices, :class_name => 'Transaction', :foreign_key => :recipient_id
  
  has_attached_file :avatar, 
                    :storage => :s3,
                    :bucket => 'simpleMoney-dev',
                    :s3_credentials => {
                      :access_key_id => 'AKIAIY7BJKXSAN3JJDOA', #ENV['S3_KEY'],
                      :secret_access_key => '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' #ENV['S3_SECRET']
                    },
                    :path => "user/:attachment/:style/:id.:extension",
                    :default_url => "/images/:style/missing.png",
                    :styles => { 
                      :medium => "150x150>", 
                      :small => "75x75>"
                    }
                    
  # Overriding serializable_hash to pass extra JSON we need in our iOS app
  def serializable_hash(options = {})
    result = super((options || {}).merge(:except => [ :avatar_updated_at, :avatar_content_type, :avatar_file_name, :avatar_file_size ]))
    result[:avatar_url] = self.avatar.url(:medium)
    result[:avatar_url_small] = self.avatar.url(:small)
    result
  end
  private
    def setBalance
      self.balance = 500.00;
    end
end
