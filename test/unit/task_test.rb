require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < Test::Unit::TestCase
  fixtures :tasks, :projects

  def test_fixture
    assert_equal 3, Task.count()
    assert_equal 0, Project.find(2).tasks.length
  end

  def test_default_tasks
    tasks = Task.default_tasks
    assert_not_nil tasks
    assert tasks.length > 0
    assert_equal 'Project Lead', tasks[0].name
  end

  def test_before_save
    # empty task
    task = Task.new
    task.name = ''
    task.save!
    assert_not_nil task.id
    assert_equal '',task.name
    assert_nil task.estimation

    # task w/ no estimation
    task.name = 'test'
    task.save!
    assert_equal 0, task.estimation

    # task with no name but duration
    task.name = ''
    task.estimation = 10
    task.save!
    assert_nil task.estimation
  end

end
