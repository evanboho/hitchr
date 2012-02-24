# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  firstname          :string(255)
#  lastname           :string(255)
#  email              :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

require 'digest/hmac'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :firstname, :lastname, :email, :password, :password_confirmation, :admin
  
  has_many :rides, :dependent => :destroy
  has_one :profile, :dependent => :destroy
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :firstname, :presence => true,
                   :length   => { :maximum => 20 }
  validates :lastname, :presence => true,
                   :length   => { :maximum => 20 }                   
  
  validates :email, :presence   => true, 
                    :format     => { :with => email_regex },
      			    :uniqueness => { :case_sensitive => false },
      			    :length     => { :minimum => 3 },
      			    :length     => { :maximum => 50 }
  
  validates :password, :presence     => true,
                       :confirmation => true,  
                       :length       => { :within => 6..12 }, :on => :create
  
  before_save :encrypt_password
  before_save :titleize_name
  
  def titleize_name
    self.firstname = firstname.try(:titleize)
    self.lastname = lastname.try(:titleize)
  end
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  private
  
    def encrypt_password
      return if !password.present?
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
  
end
