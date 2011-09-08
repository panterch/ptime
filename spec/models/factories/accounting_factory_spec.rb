require 'spec_helper'

describe Accounting do
  it 'has a valid factory' do
    accounting = Factory.build(:accounting)
    accounting.should be_valid
  end
end
