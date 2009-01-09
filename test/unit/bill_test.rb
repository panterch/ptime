require File.dirname(__FILE__) + '/../test_helper'

class BillTest < Test::Unit::TestCase
  fixtures :bills, :projects, :entries, :users, :tasks

  # Replace this with your real tests.
  def test_to_csv
    bill = Bill.new
    bill.project = Project.find(1)
    bill.name = 'testbill'
    entry = Entry.find(1)
    bill.entries << entry
    expected = <<EOF
Test,testbill
2007-05-28,1.5,Test,task 1,seb,A complete entry
EOF
    assert_equal expected, bill.to_csv
  end
end
