require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Project do
  before(:each) do
    User.delete_all
    Story.delete_all
    Work.delete_all
    Project.delete_all
    Iteration.delete_all
  end

  it "should retrieve or create iteration given a number" do
    project = Project.create(:name => "sample project")
    iteration = project.iteration_number(1)
    project.should have(1).iteration
  end
 
end
