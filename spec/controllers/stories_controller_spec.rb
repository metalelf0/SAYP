require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe StoriesController do

  it "should show update information after parsing a string" do
    Story.should_receive(:find).with("11")
    get :index, :updated_element_type => "Story", :updated_element => "11"
  end

  it "should show a story" do
    Story.should_receive(:find).with("1")
    get :show, :id => "1"
  end

end
