require 'spec_helper'

describe "FactoryGirl" do

  describe "a post by factory" do
    let(:post) { Factory.build(:post) }
    it("should be valid") { post.should be_valid }
  end

  # this test assures that the database is cleaned up before each
  # example.
  describe "a persisted post by factory" do
    before(:each) { Factory(:post) }
    it "should create exactly one user" do
      Post.count.should eq(1)
    end
    it "and cleanup the database before each test" do
      Post.count.should eq(1)
    end
  end
  
  it "user factory is valid" do
    user=Factory.build(:user)
    user.should be_valid
  end

  it 'has a valid accounting factory' do
    accounting = Factory.build(:accounting)
    accounting.should be_valid
  end
end
