class Accounting < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :description, :amount, :valuta, :project
  attr_accessible :description, :amount, :valuta, :sent, :payed, :link

  scope :filter_sent, where(:sent => true)
  scope :filter_payed, where(:payed => true)
  scope :filter_cash_in, where('amount > 0')
  scope :filter_cash_out, where('amount < 0')
end
