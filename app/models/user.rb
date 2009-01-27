require 'digest/sha1'

class User < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_uniqueness_of :email
  validates_format_of :email,
       :with       => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
       :message    => 'email must be valid'

  has_many :engagements
  has_many :entries
  has_many :reports
  has_many :projects, :through => :engagements, :uniq => true

  # has_many :admin_projects, :source => :project, :through => :engagements,
  #          :conditions => { :role => 1 }

  attr_accessor :password_confirmation
  validates_confirmation_of :password

  def validate
    errors.add('password', "missing") if hashed_password.blank?
  end

  def self.authenticate(name, password)
    user = self.find(:first, :conditions =>
           ['name = ? OR email = ?', name, name])
    if user
      password = encrypted_password(password)
      if password != user.hashed_password
        return nil
      end
    end
    user
  end

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    self.hashed_password = User.encrypted_password(self.password)
  end

  private
  def self.encrypted_password(password)
    Digest::SHA1.hexdigest(password)
  end

end
