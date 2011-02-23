require 'spec_helper'

describe "posts/new.html.haml" do
  before do
    @post = Factory.build(:post)
    assign(:post, @post)
  end

  it "displays the text attribute of the post" do
    view.should_receive(:collection_path).and_return(new_post_path)
    render
    rendered.should =~ /#{@post.title}/
  end

  it "renders a form to create a post" do 
    view.should_receive(:collection_path).and_return(posts_path)
    render 
    rendered.should have_selector("form",
                                  :method => "post",
                                  :action => posts_path ) do |form|
      form.should have_selector("input", :type => "submit")
     end 
  end

  it "renders a text field for the post title" do
    view.should_receive(:collection_path).and_return(new_post_path)
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input",
        :type => "text",
        :name => "post[title]",
        :value => "Post title"
      )
    end
  end

  it "renders a text area for the post text" do
    view.should_receive(:collection_path).and_return(new_post_path)
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("textarea", 
        :name => "post[body]", 
        :content => "Post body"
      )
    end    
  end
end
