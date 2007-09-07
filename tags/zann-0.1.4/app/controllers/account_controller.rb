class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  before_filter :login_required, :except => [ :login, :signup, :activate, :show, :resend]
  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
    redirect_to(:controller => 'main', :action => 'index')
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => 'photos', :action => 'list')
      flash[:notice] = "Logged in successfully"
    else
      flash[:warning] = "Wrong username/password pair. Logging in failed."
    end
  end

  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    #disable auto-login on registration to enable activation
    #self.current_user = @user
    # comment out redirect_back_to_failed and instead add render :action => 'welcome'
    # Add a welcome.rhtml file to your views directory (don��t need to add anything to the controller) and you��re done.
    # redirect_back_or_default(:controller => '/account', :action => 'index')
    redirect_to :controller => 'main', :action => 'index'
    flash[:notice] = "Thanks for signing up! Please check your email inbox to activate your account first."
    @user.accepts_role 'owner', @user
    @user.save
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => 'main', :action => 'index')
  end
  
  def activate
    if params[:id]
      @user = User.find_by_activation_code(params[:id]) if params[:id]
      if @user and @user.activate
        self.current_user = @user
        redirect_back_or_default(:controller => 'main', :action => 'index')
        flash[:notice] = "Your account has been activated." 
      else
        flash[:warning] = "Unable to activate the account.  Did you provide the correct information or has your account already been activated?" 
      end
    else
      flash.clear
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
    permit "owner of :user" do
    end
  end
  
  def update
    @user = User.find(params[:id])
    permit "owner of :user" do
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your account was successfully updated.'
        redirect_to :action => 'show', :id => @user
      else
        render :action => 'edit'
      end
    end
  end
  
  def resend
    return unless request.post?
    user = User.find(:first, :conditions => ["login = ? AND activated_at IS NULL AND NOT activation_code IS NULL", params[:login]])
    if(user.nil?)
      flash[:warning] = "There's no unactivated user named #{params[:login]} existing."
    else
      flash[:notice] = "Activation email has been sent to you again. Please check your email inbox to activate your account."
      UserNotifier.deliver_signup_notification(user)
    end
    render :template => 'account/login'
  end
end
