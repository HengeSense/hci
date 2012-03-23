# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Hci::Application.initialize!

require 'tlsmail'    
Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true