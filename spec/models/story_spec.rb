require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Story do
  before(:each) do
    User.delete_all
    Story.delete_all
    Work.delete_all
    Project.delete_all
    @valid_attributes = {
      :title => "value for title"
    }
  end

  it "should create a new instance given valid attributes" do
    Story.create!(@valid_attributes)
  end

  it "should calculate its total pomodori spent" do
    Parser.parse "@Tizio e @Caio hanno lavorato alla storia #Prima Storia !10 pomodori. Ne mancano altri %10."
    Parser.parse "@Tizio e @Sempronio hanno lavorato alla storia #Prima Storia !15 pomodori. Ne mancano altri %2."
    
    Story.first.total_pomodori_spent.should eql(25)
  end
  
  it "should tell me who worked on it and how much" do
    Parser.parse "@Tizio e @Caio hanno lavorato alla storia #Prima Storia !10 pomodori. Ne mancano altri %10."
    Parser.parse "@Tizio e @Sempronio hanno lavorato alla storia #Prima Storia !15 pomodori. Ne mancano altri %2."
    
    Story.first.workers.should have(3).workers
    Story.first.workers["@Tizio"].should     eql(10 + 15)
    Story.first.workers["@Caio"].should      eql(10)
    Story.first.workers["@Sempronio"].should eql(15)
  end

end
