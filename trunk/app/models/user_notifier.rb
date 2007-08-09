class UserNotifier < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://localhost:3000/account/activate/#{user.id}?activation_code=#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://localhost:3000/"
  end
  
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "zann.emc@163.com"
    @subject     = "[ZANN] Welcome to zann "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
