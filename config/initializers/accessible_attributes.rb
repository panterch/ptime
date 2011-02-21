# make all attributes protected by default
class ActiveRecord::Base
  attr_accessible
  attr_accessor :accessible

  private

  def mass_assignment_authorizer
    if accessible == :all || Array(accessible).include?(:all)
      self.class.protected_attributes
    else
      super + (accessible || [])
    end
  end
end
