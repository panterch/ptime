class User < ActiveRecord::Base
  has_many :entries

  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable

  validates_presence_of :username

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :username
end
