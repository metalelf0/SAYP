require 'spec_helper'

describe "/stories/show.html.erb" do
  before(:each) do
    assigns[:story] = @story = stub_model(Story,
      :title => "Story title"
    )
  end

  it "should show story attributes" do
    render
    response.should have_tag("#story_title", 1)
  end

end
