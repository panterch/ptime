require File.dirname(__FILE__) + '/../test_helper'

class EntryTest < Test::Unit::TestCase
  fixtures :entries, :projects, :users, :tasks

  def setup
  end

  def test_relation
    entry = entries(:first)
    assert entry.project
    assert_equal "A project owned by me", entry.project.description
  end

  def test_to_csv
    entry = entries(:first)
    assert_equal '2007-05-28,1.5,A project owned by me,task 1,seb,A complete entry', 
      entry.to_csv
    # test escaping of the comma
    entry.description = 'desc , comma'
    assert_equal '2007-05-28,1.5,A project owned by me,task 1,seb,"desc , comma"', 
      entry.to_csv
    # test nil handling for task
    entry.task = nil
    assert_equal '2007-05-28,1.5,A project owned by me,"",seb,"desc , comma"', 
      entry.to_csv
  end

  def test_task
    @entry = entries(:first)
    assert_equal('task 1',@entry.task.name)
    @task  = Task.find(2)
    @entry.update_attribute(:task, @task)
    assert_equal('task 2',@entry.task.name)
  end

 
end
