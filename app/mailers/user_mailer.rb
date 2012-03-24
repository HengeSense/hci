class UserMailer < ActionMailer::Base
  default :from => "hcirobot@gmail.com"
  
  def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Welcome to SimpleMoney")
  end
  
  def registration_invitation(recipientEmail, sender, transaction)
    @recipientEmail = recipientEmail
    @sender = sender
    @transaction = transaction
    mail(:to => "#{recipientEmail}", :subject => "#{sender.email} sent you $#{transaction.amount}!")
  end
  
  # class Preview < MailView
  #   # Pull data from existing fixtures
  #   def registration_confirmation
  #     user = User.first
  #     UserMailer.registration_confirmation(user)
  #   end
  # 
  #   # Factory-like pattern
  #   def registration_invitation
  #     user = User.first
  #     transaction = Transaction.first
  #     mail = UserMailer.registration_invitation('bob@example.com', user, transaction)
  #     mail
  #   end
  # end
  
end