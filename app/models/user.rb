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
  attr_accessible :avatar, :name, :email, :password, :password_confirmation, :remember_me, :currency, :address, :latitude, :longitude, :is_merchant
  
  composed_of :balance,
    :class_name => "Money",
    :mapping => [%w(balance cents), %w(currency currency_as_string)],
    :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) },
    :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }
  
  has_many :bills, :class_name => 'Transaction', :foreign_key => "sender_id"
  accepts_nested_attributes_for :bills
  has_many :invoices, :class_name => 'Transaction', :foreign_key => "recipient_id"
  accepts_nested_attributes_for :invoices
    
  has_many :sellable_items,  :class_name => 'Item', :foreign_key => "merchant_id"
  has_many :purchased_items, :class_name => 'Item', :foreign_key => "buyer_id"
  accepts_nested_attributes_for :sellable_items
    
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

  scope :near, lambda{ |*args|
                      origin = *args.first[:origin]
                      if (origin).is_a?(Array)
                        origin_lat, origin_lng = origin
                      else
                        origin_lat, origin_lng = origin.latitude, origin.longitude
                      end
                      origin_lat, origin_lng = origin_lat.to_f / 180.0 * Math::PI, origin_lng.to_f / 180.0 * Math::PI
                      within = *args.first[:within]
                      {
                        :conditions => %(
                          (ACOS(COS(#{origin_lat})*COS(#{origin_lng})*COS(RADIANS(users.latitude))*COS(RADIANS(users.longitude))+
                          COS(#{origin_lat})*SIN(#{origin_lng})*COS(RADIANS(users.latitude))*SIN(RADIANS(users.longitude))+
                          SIN(#{origin_lat})*SIN(RADIANS(users.latitude)))*3963) <= #{within[0]}
                        ),
                        :select => %( users.*,
                          (ACOS(COS(#{origin_lat})*COS(#{origin_lng})*COS(RADIANS(users.latitude))*COS(RADIANS(users.longitude))+
                          COS(#{origin_lat})*SIN(#{origin_lng})*COS(RADIANS(users.latitude))*SIN(RADIANS(users.longitude))+
                          SIN(#{origin_lat})*SIN(RADIANS(users.latitude)))*3963) AS distance
                        )
                      }
                    }
                    
  # Overriding serializable_hash to pass extra JSON we need in our iOS app
  def as_json(options = {})
    result = super((options || {}).merge(:except => [ :balance, :avatar_updated_at, :avatar_content_type, :avatar_file_name, :avatar_file_size ]))
    result[:avatar_url] = self.avatar.url(:medium)
    result[:avatar_url_small] = self.avatar.url(:small)
    a = self.invoices
    b = self.bills
    transactions = (a+b).sort!{|a,b|a.created_at <=> b.created_at}
    result[:transactions] = transactions.reverse()
    result
  end
  
  def serializable_hash(options = {})
    result = super((options || {}).merge(:except => [:balance, :avatar_updated_at, :avatar_content_type, :avatar_file_name, :avatar_file_size ]))
    result[:avatar_url] = self.avatar.url(:medium)
    result[:avatar_url_small] = self.avatar.url(:small)
    result[:balance] = self.balance.cents
    result
  end
  
  def increaseBalance(amount)
    logger.debug('increasing balance')    
    self.balance = self.balance + Money.new(amount)
    logger.debug(self.balance)
    self.save
  end
  
  def decreaseBalance(amount)
    logger.debug('decreasing balance')
    self.balance = self.balance - Money.new(amount)
    logger.debug(self.balance)
    self.save
  end

  def deg2rad(degrees)
    degrees.to_f 
  end
  
  private
    def setBalance
      self.balance = 5000000
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
