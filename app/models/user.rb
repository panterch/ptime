require 'digest/sha1'

class User < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  # Authorization plugin
  acts_as_authorized_user
  acts_as_authorizable

  has_many :entries

  attr_accessor :password_confirmation
  validates_confirmation_of :password

  def validate
    errors.add_to_base("Missing password") if hashed_password.blank?
    if admin? and inactive
      errors.add(:inactive, "Cannot inactivate admin users")
    end
  end

  # check if we removed the last admin
  def after_save
    if 1 > Role.count(:conditions => 'name = "admin"')
      self.admin = true
    end
  end

  def admin
    self.has_role? 'admin'
  end
  alias admin? admin

  def admin=(flag)
    flag = flag.to_i if flag.is_a? String # rails checkbox wrapper
    flag = (flag > 0) if flag.is_a? Fixnum
    flag ? self.has_role('admin') : self.has_no_role('admin')
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
