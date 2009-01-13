require File.dirname(__FILE__) + '/../test_helper'

class EntryTest < Test::Unit::TestCase
  fixtures :entries, :projects, :users, :tasks

  def setup
  end

  def test_create
    entry = entries(:first)
    assert_kind_of Entry, entry
    assert_equal "A complete entry", entry.description
    assert_equal 2007, entry.date.year
    assert_equal 5, entry.date.mon
    assert_equal 28, entry.date.day
    assert_equal 'Test', entry.project.description
    assert_equal 'seb', entry.user.name

    entry = entries(:another)
    assert_kind_of Entry, entry
    assert_equal "Another entry", entry.description
    assert_equal 2008, entry.date.year
    assert_equal 1, entry.date.mon
    assert_equal 1, entry.date.day
  end

  def test_relation
    entry = entries(:first)
    assert entry.project
    assert_equal "Test", entry.project.description
  end

  def test_to_csv
    entry = entries(:first)
    assert_equal '2007-05-28,1.5,Test,task 1,seb,A complete entry', 
      entry.to_csv
    # test escaping of the comma
    entry.description = 'desc , comma'
    assert_equal '2007-05-28,1.5,Test,task 1,seb,"desc , comma"', 
      entry.to_csv
    # test nil handling for task
    entry.task = nil
    assert_equal '2007-05-28,1.5,Test,"",seb,"desc , comma"', 
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
