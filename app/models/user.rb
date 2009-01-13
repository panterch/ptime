require 'digest/sha1'

class User < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :entries

  attr_accessor :password_confirmation
  validates_confirmation_of :password

  def validate
    errors.add_to_base("Missing password") if hashed_password.blank?
  end

  def self.authenticate(name, password)
    user = self.find(:first, :conditions =>
           ['name = ? AND inactive = ?', name, false])
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
