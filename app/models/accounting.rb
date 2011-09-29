class Accounting < ActiveRecord::Base
  belongs_to :project
  before_save :save_sign

  has_attached_file :document

  validates_presence_of :description, :amount, :valuta, :project
  attr_accessible :description, :amount, :valuta, :sent, :payed, :link, :document

  default_scope where(:deleted_at => nil)

  def save_sign
    self.positive = ( self.amount >= 0 ) ? true : false
    true
  end

  def mark_as_deleted
    self.deleted_at = Time.now
    self.save
  end
end
