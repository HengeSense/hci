class Item < ActiveRecord::Base
  before_create :setMerchant
  
  belongs_to :transaction
  belongs_to :merchant, :class_name => "User"
  belongs_to :buyer, :class_name => "User"
  
  has_many :price_points
  accepts_nested_attributes_for :price_points
  
  attr_accessible :photo, :name, :merchant_id, :buyer_id, :description, :purchase_price, :price_points_attributes
  
  composed_of :purchase_price,
    :class_name => "Money",
    :mapping => [%w(purchase_price cents), %w(currency currency_as_string)],
    :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) },
    :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }
  
  has_attached_file :photo, 
                    :storage => :s3,
                    :bucket => 'simpleMoney-dev',
                    :s3_credentials => {
                      :access_key_id => 'AKIAIY7BJKXSAN3JJDOA', #ENV['S3_KEY'],
                      :secret_access_key => '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' #ENV['S3_SECRET']
                    },
                    :path => "item/:attachment/:style/:id.:extension",
                    :default_url => "/images/:style/missing_item.png",
                    :styles => { 
                      :medium => "150x150>",
                      :small => "75x75>"
                    }
                    
  def as_json(options = {})
    result = super((options || {}).merge(:include => [:price_points], :except => [:purchase_price, :photo_content_type, :photo_file_name, :photo_file_size, :photo_updated_at]))
    result[:photo_url] = self.photo.url(:medium)
    result[:photo_url_small] = self.photo.url(:small)
    result[:purchase_price] = self.purchase_price.cents
    result
  end
  
  def serializable_hash(options = {})
    result = super((options || {}).merge(:include => [:price_points], :except => [:purchase_price, :photo_content_type, :photo_file_name, :photo_file_size, :photo_updated_at]))
    result[:photo_url] = self.photo.url(:medium)
    result[:photo_url_small] = self.photo.url(:small)
    result[:purchase_price] = self.purchase_price.cents
    result
  end
  
  def setMerchant
    if self.transaction
      self.merchant_id = self.transaction.recipient.id
    else
      self.merchant_id = self.merchant.id      
    end
    
  end
  
end
