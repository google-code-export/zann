class UserNotifier < ActionMailer::Base
  ZANN_SERVER_ADDRESS = '152.62.42.58'
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Registration Verification'
    @body[:url]  = "http://#{ZANN_SERVER_ADDRESS}:3000/account/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{ZANN_SERVER_ADDRESS}:3000/main"
  end
  
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "donotreply@emccrdc.com"
    @subject     = "[ZANN]"
    @sent_on     = Time.now
    @body[:user] = user
  end
end
