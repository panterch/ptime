require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < Test::Unit::TestCase
  fixtures :projects, :tasks, :entries

  def test_fixture
    project = Project.find(1)
    assert project
    assert_equal "Test", project.description
    assert_equal 4, project.entries.count
    assert_equal 3, project.tasks.count
  end

  def test_create
    project = Project.new
    project.description = 'newly created'
    project.save
    project.reload
    assert_not_nil project.id
    assert_equal 'newly created', project.description
  end

  def testInactive
    assert !Project.find(1).inactive?
    assert Project.find(2).inactive?
    project = Project.find(2)
    project.update_attribute(:inactive, false)
    assert !Project.find(2).inactive?
  end

  def testFindByInactive
    i = Project.count(:all, :conditions => ['inactive = ?', false])
    assert_equal(1,i)
    i = Project.count(:all, :conditions => ['inactive = ?', true])
    assert_equal(1,i)
    projects = Project.find(:all, :conditions => ['inactive = ?', false])
    assert_equal(1,projects.length) 

  end

  def test_add_empty_tasks
    p = Project.new
    p.add_empty_tasks
    assert_equal 10, p.tasks.length
    p.add_empty_tasks(1)
    assert_equal 11, p.tasks.length
  end

  def test_total_time_used
    p = Project.find(1)
    assert_equal 10, p.total_time_used
  end

  def test_total_time_estimated
    p = Project.find(1)
    assert_equal 40, p.total_time_estimated
  end

  def test_percent_time_used
    p = Project.find(1)
    assert_equal 25.0, p.percent_time_used
  end

  def test_no_estimation
    p = Project.new
    assert_equal 0, p.total_time_estimated
    assert_equal 0, p.percent_time_used
  end

  def test_time_used_per_task
    p = Project.find(1)
    t = p.time_used_per_task
    assert_equal 2, t.length
    assert_equal 3.5, t[nil]
    assert_equal 6.5, t[1]

    #simultate the case where a task was resetted
    p.tasks.each do |t|
      t.name = ''
    end
    t = p.time_used_per_task
    assert_equal 10, t[nil]
    assert_equal 0, t[1]
  end

end
