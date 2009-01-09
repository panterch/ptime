require File.dirname(__FILE__) + '/../test_helper'
require 'entries_controller'


class ApplicationHelperTest < Test::Unit::TestCase

  include ApplicationHelper

  def setup
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def testActiveWhenController
    @controller = EntriesController.new
    assert_equal 'active', activeWhenController('entries')
    assert_equal '', activeWhenController('projects')
  end

end
