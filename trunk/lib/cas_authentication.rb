module CASAuthentication
  def cas_login
    # in some cases, "corp\nt_alias" or "cas.example.com\nt_alias" will be returned
    nt_alias = session[:cas_user].split('\\').last
    user = User.find_or_initialize_by_login(nt_alias)
    if(user.new_record?)
      user.email = "#{session[:cas_user]}@#{CONFIG['email_domain']}"
      user.save!
      user.activate
      user.accepts_role 'owner', user
    end
    self.current_user = user
  end
end