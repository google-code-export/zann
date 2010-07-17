module CASAuthentication
  def cas_login
    user = User.find_or_initialize_by_login(session[:cas_user])
    if(user.new_record?)
      user.email = "#{session[:cas_user]}@#{CONFIG['email_domain']}"
      user.save!
      user.activate
      user.accepts_role 'owner', user
    end
    self.current_user = user
  end
end