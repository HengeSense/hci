class Transaction < ActiveRecord::Base
  belongs_to :sender,    :class_name => "User", :foreign_key => "sender_email",    :primary_key => "email"
  belongs_to :recipient, :class_name => "User", :foreign_key => "recipient_email", :primary_key => "email"
  attr_accessible :recipient_email, :sender_email, :description, :amount, :complete
  
  
  def as_json(options = {})
    result = super((options || {}).merge(:include => [:sender , :recipient ]))
    result
  end
    
end
