  require File.dirname(__FILE__) + '/../test_helper'
  require 'report_controller'

  # Re-raise errors caught by the controller.
  class ReportController; def rescue_action(e) raise e end; end

  class ReportControllerTest < Test::Unit::TestCase

    fixtures :users, :entries, :projects, :tasks


    def setup
      @controller = ReportController.new
      @request    = ActionController::TestRequest.new
      @response   = ActionController::TestResponse.new

      @params_with_values = { 
        :start => { :year => 2007, :month => 5, :day => 28 },
        :end => { :year => 2007, :month => 5 , :day => 28 },
        :post => {} }
    end

    def test_render
      get(:index, nil, { :user_id => users(:seb) })
      assert_response 200
    end
      

    def test_preview()
    get(:preview,@params_with_values, { :user_id => users(:seb) })
    assert_equal 3, assigns('count')
    assert_response 200
  end

  def test_download()
    post(:download,@params_with_values, { :user_id => users(:seb) })
    expected = <<EOF
2007-05-28,2.5,Test,task 1,dilbert,An entry by another user
2007-05-28,2.5,Test,task 1,seb,"A complete entry, the second"
2007-05-28,1.5,Test,task 1,seb,A complete entry
EOF
    assert_equal expected, @response.body
  end

  def test_params_to_condition()
    params = { :start => { :year => 2001, :month => 1 , :day => 1 },
      :end => { :year => 2008, :month => 12 , :day => 31 },
      :post => {} }
    expected = ['date >= ? AND date <= ?', Date.civil(2001,1,1),
      Date.civil(2008,12,31)]
    assert_equal expected, @controller.paramsToConditions(params)

    params[:post][:project_id] = '1'
    expected[0] += ' AND project_id = ?'
    expected[3] = 1
    assert_equal expected, @controller.paramsToConditions(params)

    params[:post][:user_id] = '2'
    expected[0] += ' AND user_id = ?'
    expected[4] = 2
    assert_equal expected, @controller.paramsToConditions(params)
  end

  def test_params_to_date()
    params = { :year => 2001, :month => 12 , :day => 31 }
    date = @controller.paramsToDate(params)
    assert_equal 2001, date.year
    assert_equal 12, date.month
    assert_equal 31, date.day
  end
end
