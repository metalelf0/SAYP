require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Project do
  before(:each) do
    User.delete_all
    Story.delete_all
    Work.delete_all
    Project.delete_all
    Iteration.delete_all
  end

  it "should add an iteration for today" do
    project = Project.create(:name => "Sample")
    project.add_iteration_for(Date.today)
    project.iterations.count.should eql(1)
    iteration = project.iterations.first
    iteration.start_date.should eql(Date.today.beginning_of_week)
    iteration.end_date.should eql(Date.today.end_of_week)
  end
 
end
