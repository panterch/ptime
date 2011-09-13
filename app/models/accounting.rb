class Accounting < ActiveRecord::Base
  belongs_to :project
  before_save :save_sign

  validates_presence_of :description, :amount, :valuta, :project
  attr_accessible :description, :amount, :valuta, :sent, :payed, :link

  def save_sign
    self.positive = ( self.amount >= 0 ) ? true : false
    true
  end
end
