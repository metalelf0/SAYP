require 'spec_helper'

describe "/stories/show.html.erb" do
  before(:each) do
    assigns[:story] = @story = stub_model(Story,
      :title => "Story title",
      :iteration => stub_model(Iteration,
                               :number => 1
                              ),
      :project => stub_model(Project,
                             :name => "Sample project"
                          )
    )
  end

  it "should show story attributes" do
    render
    response.should have_tag("#story_title", 1)
    response.should have_tag("#story_project_name", "Sample project")
  end

end
