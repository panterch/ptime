require 'spec_helper'

describe "posts/new.html.haml" do
  before do
    @post = Factory.build(:post)
    assign(:post, @post)
  end

  it "displays the text attribute of the message" do
    render
    rendered.should contain("Title")
  end
end
