class Transaction < ActiveRecord::Base
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_email"
  belongs_to :recipient, :class_name => "User", :foreign_key => "recipient_email"
  attr_accessible :recipient_email, :sender_email, :description, :amount, :complete
end
