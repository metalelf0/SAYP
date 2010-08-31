require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Parser do
  before(:each) do
    User.delete_all
    Story.delete_all
    Work.delete_all
    Project.delete_all
    Iteration.delete_all
  end

  it "should correctly parse a phrase about a beginning story" do
    edited_story = Parser.parse "@Tizio e @Caio hanno lavorato alla storia #Prima Storia !10 pomodori. Ne mancano altri %10."
    Story.count.should eql(1)
    story = Story.first
    story.title.should eql("Prima Storia")
    work = Work.first
    work.pomodori.should eql(10)
    work.remaining.should eql(10)
    work.story.should eql(story)
    User.count.should eql(2)
    tizio = User.find_by_alias("@Tizio")
    tizio.should_not be_nil
    caio = User.find_by_alias("@Caio")
    caio.should_not be_nil
    work.users.should include(tizio, caio)
    tizio.works.should include(work)
    edited_story.should eql(Story.first)
  end

  it "should parse a phrase to create a project" do
    edited_project = Parser.parse "Oggi è iniziato il progetto @Epi."
    Project.count.should eql(1)
    Project.first.name.should eql("Epi")
    edited_project.should eql(Project.first)
  end
  
  it "should associate stories to project" do
    out = Parser.parse "Storie per il progetto @Epi: #Prima storia, #Seconda storia, #Ultimissima storia."
    Project.first.should have(3).stories
    Project.first.should have(0).planned_stories # there are still no stories associated to iterations
    Project.first.name.should eql("Epi")
    Story.find_by_title("Prima storia").should_not be_nil
    Story.find_by_title("Seconda storia").should_not be_nil
    Story.find_by_title("Ultimissima storia").should_not be_nil
  end
          
  it "should add an iteration to project when creating it" do
    out = Parser.parse "Oggi è iniziato il progetto @Project."
    Project.count.should eql(1)
    Project.first.iterations.count.should eql(1)
  end

  it "should associate stories to iterations" do
    out  = Parser.parse "Progetto @Epi, iterazione 1: #Prima storia, #Seconda storia"
    out2 = Parser.parse "Progetto @Epi, iterazione 2: #Terza storia"
    Project.first.should have(2).iterations
    Project.first.iterations.first.should have(2).stories
    Project.first.should have(3).planned_stories
    Project.first.should have(3).stories # stories must be associated to project backlog, too
    
    Project.first.name.should eql("Epi")
    Story.find_by_title("Prima storia").should_not be_nil
    Story.find_by_title("Seconda storia").should_not be_nil
    Story.find_by_title("Terza storia").should_not be_nil
    Project.first.iterations.count.should eql(2)
  end
  
  it "should not create duplicate iterations when adding stories to existing iteration" do
    out  = Parser.parse "Progetto @Epi, iterazione 1: #Prima storia, #Seconda storia"
    out2 = Parser.parse "Progetto @Epi, iterazione 1: #Terza storia"
    Project.first.name.should eql("Epi")
    Project.first.should have(1).iteration
  end

  it "should fail gracefully" do
    Proc.new {
      Parser.parse("Questa stringa non vuol dire un accidente").should be_nil
      Parser.parse("@Tizio e @Caio hanno lavorato alla storia #Prima Storia !10 pomodori. Ne mancano altri 10.").should be_nil
    }.should_not raise_error
  end

end
