require 'spec_helper'

describe "/projects/show.html.erb" do
  include ProjectsHelper
  before(:each) do
    assigns[:project] = @project = stub_model(Project,
      :name => "value for name"
    )
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

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
  end

  it "should show iterations under project" do
    render
    response.should have_tag(".iteration_number", 2)
  end

end
