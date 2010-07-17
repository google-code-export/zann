require 'digest/sha1'
class User < ActiveRecord::Base
  acts_as_authorized_user
  acts_as_authorizable
  has_and_belongs_to_many :roles
  # Virtual attribute for the unencrypted password
  attr_accessor :password
#  file_column :avatar
  validates_presence_of     :login, :email#, :first_name, :last_name
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_length_of       :first_name,    :maximum => 100, :allow_nil => true
  validates_length_of       :last_name,    :maximum => 100, :allow_nil => true
#  validates_length_of       :avatar,    :maximum => 200
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  #validates_format_of :email, :with => /^([^@+\s]+)_([^@+\s]+)@example\.com$/i
  before_save :encrypt_password
  before_create :make_activation_code
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    #u = find_by_login(login) # need to get the salt
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login]
    u && u.authenticated?(password) ? u : nil
  end
  
  # Activates the user in the database.
  def activate
    @activated = true
    update_attributes(:activated_at => Time.now, :activation_code => nil)
  end
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
    
  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  def full_name
    (first_name.nil? || last_name.nil?) ? login : "#{first_name} #{last_name}"
  end
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      !CONFIG['cas_enabled'] && (crypted_password.blank? || !password.blank?)
    end
    
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
end
