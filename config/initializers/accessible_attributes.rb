# make all attributes protected by default
class ActiveRecord::Base
  attr_accessible
end
