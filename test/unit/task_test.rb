require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < Test::Unit::TestCase
  fixtures :tasks, :projects

  def test_fixture
    assert_equal 3, Task.count()
  end

  def test_default_tasks
    tasks = Task.default_tasks
    assert_not_nil tasks
    assert tasks.length > 0
    assert_equal 'Project Lead', tasks[0].name
  end

end
