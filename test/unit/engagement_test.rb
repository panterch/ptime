require 'test_helper'

class EngagementTest < ActiveSupport::TestCase

  def test_create_admin_project
    u = users(:seb)
    assert_difference 'Engagement.count' do
      assert_difference 'Project.count' do
        # This does not work sound, see 
        # http://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/635
        # u.admin_projects.create(:description => 'create_admin_project')
        e = u.engagements.build(:role => 1)
        e.create_project(:description => 'create_admin_project')
        e.save!
      end
    end
    assert Project.last.users.include? users(:seb)
    assert_equal 1, Engagement.last.role
    
  end
end
