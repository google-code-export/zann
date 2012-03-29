module CASAuthentication
  def cas_login
    # in some cases, "corp\nt_alias" or "cas.example.com\nt_alias" will be returned
    # puts "#{session[:cas_user]} logs in"
    nt_alias = session[:cas_user].split('\\').last.split('\\').last.downcase
    user = User.find_or_initialize_by_login(nt_alias)
    if(user.new_record?)
      user.email = "#{nt_alias}@#{CONFIG['email_domain']}"
      user.save!
      user.activate
      user.accepts_role 'owner', user
    end
    self.current_user = user
  end
end