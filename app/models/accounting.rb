class Accounting < ActiveRecord::Base

  has_paper_trail # versioning

  belongs_to :project
  before_save :set_sign

  has_attached_file :document

  validates_presence_of :description, :amount, :valuta, :project
  attr_accessible :description, :amount, :valuta, :sent, :payed, :link, :document

  default_scope where(:deleted_at => nil).order(:valuta)

  def destroy_with_mark
    self.deleted_at = Time.now
    save
  end
  alias_method_chain :destroy, :mark

  private

  def set_sign
    self.positive = (self.amount >= 0)
    true
  end

end
