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
        return nil
      end
    end

    def Parser.parse_project_creation phrase
      if !(phrase.include?("@"))
        raise "Project name not found (must start with @)"
        return nil
      end
      project_name = phrase.split("@")[1]
      project = Project.create_with_iteration(project_name)
      return project
    end

    def Parser.parse_add_story_to_project phrase
      # Storie per il progetto @Epi: #Prima storia, #Seconda storia, #Ultimissima storia
      project_name = phrase.split(" ").select {|token| token.start_with?("@") }.first.gsub("@", "").gsub(":", "")
      project = Project.find_or_create_by_name(project_name)
      story_titles = phrase.split(": ")[1].gsub(", ", "").split("#").reject { |el| el.blank? }
      story_titles.each do |story_title|
        story = Story.find_or_create_by_title(story_title)
        story.status = Story::TODO; story.save
        project.stories << story
      end
      return project
    end

    def Parser.parse_work_entry phrase
      # @Tizio e @Caio hanno lavorato alla storia #Prima Storia !10 pomodori. Ne mancano altri %10.
      story_title = phrase.split("#")[1].split(" !")[0].strip
      pomodori = phrase.split("#")[1].split("!")[1].to_i
      users = phrase.split(" ").select { |token| token.start_with?("@") }
      first_token = phrase.split(" ").select { |token| token[0..0] == "%" }.first
      remaining = first_token[1..-1].to_i
      story = Story.find_or_create_by_title(story_title)
      story.status = ( remaining == 0 ? Story::TO_VERIFY : Story::IN_PROGRESS )
      story.save!
      work = Work.create(:pomodori => pomodori, :story => story)
      users.each do |user_alias|
        user = User.find_or_create_by_alias(user_alias)
        work.users << user
      end
      work.remaining = remaining
      work.save!
      
      return story
    end

    def Parser.parse_add_story_to_iteration phrase
      # Progetto @Epi, iterazione 1: #Prima storia, #Seconda storia
      story_titles = phrase.split(":").last.split("#").map { |story_name| story_name.gsub(/[, ]+$/, "") }
      story_titles.delete("")
      project_name = phrase.split("@")[1].split(",")[0]
      iteration_number = phrase.split(":")[0].split("iterazione ")[1]
      project = Project.find_or_create_by_name(project_name)
      iteration = project.iteration_number(iteration_number)
      story_titles.each do |story_title|
        story = Story.find_or_create_by_title(story_title)
        story.iteration = iteration
        story.save
        project.stories << Story.find_or_create_by_title(story_title)
      end
      return iteration
    end

end
