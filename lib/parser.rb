class Parser

  AVAILABLE_FORMATS = ["@Tizio e @Caio hanno lavorato alla storia #Prima Storia !10 pomodori. Ne mancano altri %10",
    "Oggi è iniziato il progetto @Progetto", "Storie per il progetto @Progetto: #Prima storia, #Seconda storia, #Terza storia", "Progetto @Progetto, iterazione 1: #Prima storia, #Seconda storia"]

  def Parser.parse phrase
    return if phrase.blank?
    begin
      phrase = phrase.gsub(".", "")
      if phrase =~ /lavorato/
        Parser.parse_work_entry phrase
        elsif phrase =~ /iniziato il progetto/
          Parser.parse_project_creation phrase
        elsif phrase =~ /Storie per il progetto/
          Parser.parse_add_story_to_project phrase
        elsif phrase =~ /Progetto.*, iterazione.*/i
          Parser.parse_add_story_to_iteration phrase
        else
          raise "Exception: no format match"
        end
      rescue Exception => e
        # puts e.message
        return nil
      end
    end

    def Parser.parse_project_creation phrase
      return nil if !(phrase.include?("@"))
      project_name = phrase.split("@")[1]
      project = Project.create_with_iteration(project_name)
      return [project, "Project"]
    end

    def Parser.parse_add_story_to_project phrase
      # Storie per il progetto @Epi: #Prima storia, #Seconda storia, #Ultimissima storia
      project_name = phrase.split(" ").select {|token| token.start_with?("@") }.first.gsub("@", "").gsub(":", "")
      puts "Creating project with name #{project_name}"
      project = Project.find_or_create_by_name(project_name)
      puts project.inspect
      story_titles = phrase.split(": ")[1].gsub(", ", "").split("#").reject { |el| el.blank? }
      story_titles.each do |story_title|
        project.stories << Story.find_or_create_by_title(story_title)
      end
      return [project, "Project"]
    end

    def Parser.parse_work_entry phrase
      # @Tizio e @Caio hanno lavorato alla storia #Prima Storia !10 pomodori. Ne mancano altri %10.
      story_title = phrase.split("#")[1].split(" !")[0].strip
      pomodori = phrase.split("#")[1].split("!")[1].to_i
      story = Story.find_or_create_by_title(story_title)
      work = Work.create(:pomodori => pomodori, :story => story)
      users = phrase.split(" ").select { |token| token.start_with?("@") }.each do |user_alias|
        user = User.find_or_create_by_alias(user_alias)
        work.users << user
      end
      first_token = phrase.split(" ").select { |token| token[0..0] == "%" }.first
      remaining = first_token[1..-1].to_i
      work.remaining = remaining
      work.save!
      
      return [story, "Story"]
    end

    def Parser.parse_add_story_to_iteration phrase
      # Progetto @Epi, iterazione 1: #Prima storia, #Seconda storia
      story_names = phrase.split(":").last.split("#").map {|token| token.remove_ending(" ") }.map {|token| token.remove_ending(",") }
      story_names.delete("")
      project_name = phrase.split("@")[1].split(",")[0]
      iteration_number = phrase.split(":")[0].split("iterazione ")[1]
      project = Project.find_or_create_by_name(project_name)
      iteration = Iteration.create(:project => project, :number => iteration_number)
      story_names.each do |story_name|
        story =       Story.find_or_create_by_title(story_name)
        story.iteration = iteration
        story.save
      end
    end

end
