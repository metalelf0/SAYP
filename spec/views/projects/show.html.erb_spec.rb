require 'spec_helper'

describe "/projects/show.html.erb" do
  include ProjectsHelper
  before(:each) do
    assigns[:project] = @project = stub_model(Project,
      :number => 1,
      :name => "value for name"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/value\ for\ name/)
  end
end
