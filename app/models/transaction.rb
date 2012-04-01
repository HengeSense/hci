class Transaction < ActiveRecord::Base
  #before_save :total
  default_scope :order => 'created_at DESC'
  belongs_to :sender,    :class_name => "User"
  belongs_to :recipient, :class_name => "User"
  attr_accessible :recipient_email, :sender_email, :description, :amount, :complete, :items_attributes
  
  composed_of :amount,
    :class_name => "Money",
    :mapping => [%w(amount cents), %w(currency currency_as_string)],
    :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) },
    :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }

  has_many :items
  accepts_nested_attributes_for :items
  
  def as_json(options = {})
    result = super((options || {}).merge(:include => [:sender , :recipient, :items], :except => :amount))
    result[:amount] = self.amount.cents
    result
  end
  
  def total
    total = 0
    self.items.each do |i|
      total += i.purchase_price.cents
      logger.debug total
    end
    self.amount = Money.new(total)
    total
  end
    
end