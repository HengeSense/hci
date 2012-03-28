class UserMailer < ActionMailer::Base
  default :from => "hcirobot@gmail.com"
  
  def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Welcome to SimpleMoney")
  end
  
  def sendMoney_invitation(recipientEmail, sender, transaction)
    @recipientEmail = recipientEmail
    @sender = sender
    @transaction = transaction
    if @sender.avatar_file_name
      @senderAvatar = @sender.avatar.url(:small)
    else
      @senderAvatar = 'http://severe-leaf-6733.herokuapp.com/images/small/missing.png'
    end
    mail(:to => "#{recipientEmail}", :subject => "#{sender.email} sent you $#{transaction.amount}!")
  end
  
  def requestMoney_invitation(recipientEmail, sender, transaction)
    @recipientEmail = recipientEmail
    @sender = sender
    @transaction = transaction
    if @sender.avatar_file_name
      @senderAvatar = @sender.avatar.url(:small)
    else
      @senderAvatar = 'http://severe-leaf-6733.herokuapp.com/images/small/missing.png'
    end
    mail(:to => "#{recipientEmail}", :subject => "#{sender.email} requested $#{transaction.amount} from you.")
  end
  
  
  if Rails.env.development?
    class Preview < MailView
      # Pull data from existing fixtures
      def registration_confirmation
        user = User.first
        UserMailer.registration_confirmation(user)
      end

      # Factory-like pattern
      def registration_invitation
        user = User.first
        transaction = Transaction.first
        mail = UserMailer.registration_invitation('bob@example.com', user, transaction)
        mail
      end
    end
  end
  
end
