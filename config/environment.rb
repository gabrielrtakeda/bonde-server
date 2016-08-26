# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :domain => ENV["APP_DOMAIN"],
  :user_name => ENV["SMTP_USERNAME"],
  :password => ENV["SMTP_PASSWORD"],
  :address => ENV["SMTP_ADDRESS"],
  :port => ENV["SMTP_PORT"],
  :authentication => :plain,
  :enable_starttls_auto => true
}
