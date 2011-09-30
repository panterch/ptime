class User < ActiveRecord::Base
  has_many :entries

  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable

  validates_presence_of :username

  default_scope where(:deleted_at => nil)

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :username

  def mark_as_deleted
    User.transaction do
      self.deleted_at = Time.now
      self.save

      self.entries.each do |entry|
        entry.mark_as_deleted
      end
    end
  end
end
