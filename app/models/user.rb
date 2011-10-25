class User < ActiveRecord::Base

  has_paper_trail # versioning

  has_many :entries

  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable

  validates_presence_of :username

  default_scope where(:deleted_at => nil)

  scope :ordered, order('username')

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :username, :admin, :external, :active

  def destroy_with_mark
    User.transaction do
      self.deleted_at = Time.now
      self.save

      self.entries.each do |entry|
        entry.destroy
      end
    end
  end

  alias_method_chain :destroy, :mark
end
