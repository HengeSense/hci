class User < ActiveRecord::Base
  before_create :setBalance
  after_create  :sendConfirmation
  after_create  :checkInvoices
  after_create  :checkBills
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :avatar, :name, :email, :password, :password_confirmation, :remember_me
  
  #has_many :bills, :class_name => 'Transaction', :foreign_key => "sender_email", :primary_key => "email"
  has_many :bills, :class_name => 'Transaction', :foreign_key => "sender_id"
  #has_many :invoices, :class_name => 'Transaction', :foreign_key => "recipient_email", :primary_key => "email"
  has_many :invoices, :class_name => 'Transaction', :foreign_key => "recipient_id"
  
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
  def as_json(options = {})
    result = super((options || {}).merge(:except => [ :avatar_updated_at, :avatar_content_type, :avatar_file_name, :avatar_file_size ]))
    result[:avatar_url] = self.avatar.url(:medium)
    result[:avatar_url_small] = self.avatar.url(:small)
    a = self.invoices
    b = self.bills
    transactions = (a+b).sort!{|a,b|a.created_at <=> b.created_at}
    result[:transactions] = transactions.reverse()
    result
  end
  
  def serializable_hash(options = {})
    result = super((options || {}).merge(:except => [ :avatar_updated_at, :avatar_content_type, :avatar_file_name, :avatar_file_size ]))
    result[:avatar_url] = self.avatar.url(:medium)
    result[:avatar_url_small] = self.avatar.url(:small)
    result
  end
  
  def increaseBalance(amount)
    logger.debug('increasing balance')    
    self.balance += amount
    logger.debug(self.balance)
    self.save
  end
  
  def decreaseBalance(amount)
    logger.debug('decreasing balance')
    self.balance -= amount
    logger.debug(self.balance)
    self.save
  end
  
  private
    def setBalance
      self.balance = 500.00
    end
    
    def sendConfirmation
      UserMailer.registration_confirmation(self).deliver
    end
    
    def checkInvoices
      invoices = Transaction.all(:conditions => {
        :recipient_email => self.email,
        :complete => true
      })
      if invoices and invoices.count > 0
        invoices.each do |t|
          self.increaseBalance(t.amount)
          t.recipient_id = self.id
          t.recipient_email = self.email
          t.save
        end
      end
    end
    
    def checkBills
      bills = Transaction.all(:conditions => {
        :sender_email => self.email,
        :complete => false
      })
      if bills and bills.count > 0
        bills.each do |t|
          t.sender_id = self.id
          t.sender_email = self.email
          t.save
        end
      end
    end
    
end
