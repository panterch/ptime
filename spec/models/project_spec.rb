require 'spec_helper'

describe Project do

  it "initializes" do
    Project.new.should_not be_nil
  end

  context "mass assignment" do
    before(:each) do
      @project = Factory(:project)
    end

    it "should have a referenced project state" do
      @project.project_state.should_not be_nil
    end

    it "should have default tasks" do
      @project.tasks.should_not be_nil
    end

    it "should delete associated tasks when a parent project is deleted" do
      @project.save
      task_id = @project.tasks[0].id
      @project.destroy
      begin
        assert_equal nil, Task.find(task_id)
      rescue ActiveRecord::RecordNotFound => e
        e.message.should match /Couldn't find Task with id.*/
      end
    end

    it "should allow mass assignement for title and body" do
      project = Project.new(:shortname => 'title', :description => 'body')
      project.shortname.should be_present
      project.description.should be_present
    end

    it "should allow mass assignment for project" do
      project = Project.new(:shortname => 'title', :description => 'body', :note => "note" )

      project.note.should be_present
    end

  end

  context "validations" do
    it "should require project_state" do
      project = Factory.build(:project, :project_state => nil)
      project.should_not be_valid
      project.errors[:project_state].should be_present
    end

    it 'should require an hourly wage' do
      project = Factory.build(:project, :wage => nil)
      project.should_not be_valid
      project.errors[:wage].should be_present
    end

    it 'should require a required responsibility' do
      res = Factory.create(:required_responsibility_type)
      project = Factory.build(:project, :responsibilities =>
                              [Factory.build(:required_responsibility,
                                             :user_id => nil)])
      project.should_not be_valid
      project.errors[:base].should be_present
    end

    it 'should have unique shortname' do
      project1 = Factory.create(:project, :shortname => 'abc-123')
      project2 = Factory.build(:project, :shortname => 'abc-123')

      project2.should_not be_valid
      project2.errors[:shortname].should be_present
    end

  end

  context "Format validation" do
    it "should discard non-conforming shortnames" do
      project = Factory.build(:project, :shortname => "gross_and_wrong_name")
      project.should_not be_valid
      project.errors[:shortname].should be_present
    end

    it "should accept conforming shortnames" do
      project =  Factory.build(:project, :shortname => "abc-123")
      project.should be_valid
      project.errors[:shortname].should be_empty
    end

    it 'should discard non-conforming probability values' do
      project = Factory.build(:project, :probability => '-15')
      project.should_not be_valid
      project.errors[:probability].should be_present
    end
  end

  context 'Deleting a project' do
    before(:each) do
      @project = Factory(:project)
      Factory(:entry, :project_id => @project.id)
      Factory(:task, :project_id => @project.id)
      @project.save
      Project.all.should have(1).record
      @project.deleted_at.should be_nil
      @project.destroy
    end

    it 'should deactivate the project instead of deleting it' do
      @project.deleted_at.should_not be_nil
    end

    it 'should not be selected' do
      Project.all.should have(:no).records
    end

    it 'should also deactivate related entries' do
      @project.entries.each do |entry|
        entry.deleted_at.should_not be_nil
      end
    end

    it 'should also deactivate related tasks' do
      @project.tasks.each do |task|
        task.deleted_at.should_not be_nil
      end
    end

    it 'should also deactivate related milestones' do
      @project.milestones.each do |milestone|
        milestone.deleted_at.should_not be_nil
      end
    end

    it 'should also deactivate related accountings' do
      @project.accountings.each do |accounting|
        accounting.deleted_at.should_not be_nil
      end
    end

    it 'should also deactivate related responsibilities' do
      @project.responsibilities.each do |responsibility|
        responsibility.deleted_at.should_not be_nil
      end
    end
  end

  context 'controlling calculations' do
    before(:each) do
      @project = Factory(:project, :rpl => 1, :current_worktime => 10, :wage => 100)
    end

    it 'calculates the total time' do
      entry_one = Factory(:entry, :duration => 120, :project_id => @project.id)
      entry_two = Factory(:entry, :duration => 30, :project_id => @project.id)
      @project.total_time.should eq minutes_to_human_readable_time(630)
    end

    it 'calculates the billable time' do
      entry_one = Factory(:entry, :duration => 120, :billable => true,
                          :project_id => @project.id)
      entry_two = Factory(:entry, :duration => 30, :billable => false,
                          :project_id => @project.id)
      @project.time_billable.should eq minutes_to_human_readable_time(120)
    end

    it 'calculates the burned time' do
      entry_one = Factory(:entry, :duration => 120, :billable => true,
                          :project_id => @project.id)
      entry_two = Factory(:entry, :duration => 30, :billable => false,
                          :project_id => @project.id)
      @project.burned_time.should eq minutes_to_human_readable_time(150)
    end

    it 'calculates the budget' do
      accounting_one = Factory(:accounting, :amount => 400,
                               :project_id => @project.id)
      accounting_two = Factory(:accounting, :amount => -200,
                               :project_id => @project.id)
      @project.budget.should eq 400
    end

    it 'calculates the expected return' do
      # sums to 200
      accounting_one = Factory(:accounting, :amount => 400,
                               :project_id => @project.id)
      accounting_two = Factory(:accounting, :amount => -200,
                               :project_id => @project.id)
      # paste_work should now be -200
      entry_one = Factory(:entry, :duration => 90, :project_id => @project.id)
      entry_two = Factory(:entry, :duration => 30, :project_id => @project.id)
      # - rpl * wage = 1 * 100 = 100
      @project.expected_return.should eq -100
    end

    it 'calculates the current internal cost' do
      entry_one = Factory(:entry, :duration => 90, :project_id => @project.id)
      entry_two = Factory(:entry, :duration => 30, :project_id => @project.id)
      @project.current_internal_cost.should eq 200
    end

    it 'calculates the external cost' do
      accounting_one = Factory(:accounting, :amount => 400,
                               :project_id => @project.id)
      accounting_two = Factory(:accounting, :amount => -200,
                               :project_id => @project.id)
      @project.external_cost.should eq -200
    end

    describe 'expected profitability' do
      before(:each) do
        entry_one = Factory(:entry, :duration => 90, :project_id => @project.id)
        entry_two = Factory(:entry, :duration => 30, :project_id => @project.id)
      end

      it 'calculates' do
        accounting_one = Factory(:accounting, :amount => 400,
                                 :project_id => @project.id)
        accounting_two = Factory(:accounting, :amount => -200,
                                 :project_id => @project.id)
        # - 100/400 * (200 - (120/60 * 100) + 1*100)
        @project.expected_profitability.should eq -25.0
      end

      it 'calculates without cash in' do
        @project.expected_profitability.should eq 0.0
      end
    end

    it 'calculates the overdue amount' do
      accounting_one = Factory(:accounting, :amount => 400,
                               :valuta => Time.now.prev_month,
                               :payed => false,
                               :sent => true,
                               :project_id => @project.id)
      accounting_two = Factory(:accounting, :amount => -200,
                               :valuta => Time.now.prev_month,
                               :payed => false,
                               :sent => true,
                               :project_id => @project.id)
      @project.overdue_amount.should eq 400
    end

    def minutes_to_human_readable_time(minutes)
      (minutes / 60).to_s + ":" + "%02i" % (minutes % 60).to_s
    end
  end

  context "probability constraints" do
    before(:each) do
      @project = Factory.build(:project)
    end

    context "for the lead state" do
      before(:each) do
        @project.project_state = Factory.create(:project_state, :name => 'lead')
      end

      it 'should allow probability less than 100%' do
        @project.probability = 0.6

        @project.should be_valid
      end

      it "should not allow probability equal to 100%" do
        @project.probability = 1

        @project.should_not be_valid
        @project.errors[:base].should be_present
      end
    end
  end

end
