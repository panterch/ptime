require 'spec_helper'

describe Task do
  context 'Deleting a task' do
    before(:each) do
      @task = Factory(:task)
      @task.save
      Task.all.should have(1).record
      @task.deleted_at.should be_nil
      @task.destroy
    end

    it 'should deactivate the task instead of deleting it' do
      @task.deleted_at.should_not be_nil
    end

    it 'should not be selected' do
      Task.all.should have(:no).records
    end
  end
end
