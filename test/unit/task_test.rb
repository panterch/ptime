require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < Test::Unit::TestCase
  fixtures :tasks, :projects

  def test_fixture
    assert_equal 3, Task.count()
  end

end
