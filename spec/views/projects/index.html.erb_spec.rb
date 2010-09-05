require 'spec_helper'

describe "/projects/index.html.erb" do
  include ProjectsHelper

  before(:each) do
    assigns[:projects] = [
      @project = stub_model(Project,
        :name => "value for name"
      ),
      stub_model(Project,
        :name => "value for name"
      )
    ]
    @iterations = [
      stub_model(Iteration,
                 :number => 1,
                 :project => @project
      ),
      stub_model(Iteration,
                 :number => 2,
                 :project => @project
      ),
    ]
    @project.stub!(:iterations).and_return(@iterations)
  end

  it "renders a list of projects" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
  end
  
  it "should show iterations under project" do
    render
    response.should have_tag(".iteration_number", 2)
  end

end
