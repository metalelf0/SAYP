class Project < ActiveRecord::Base
  
  has_many :stories
  has_many :iterations
  
  def Project.create_with_iteration project_name
    project = Project.find_or_create_by_name(project_name)
    project.add_iteration_for(Date.today)
    project.save
    project
  end
  
  def iteration_number number
    already_existing = self.iterations.detect { |it| it.number == number.to_i }
    if already_existing
      return already_existing
    else
      new_iteration = Iteration.create(:number => number)
      self.iterations << new_iteration
      return new_iteration
    end
  end
  
  def add_iteration_for date   # TODO: remove this date param, its not used
    self.iterations << Iteration.create
  end

  def planned_stories
    stories = []
    iterations.each do |iteration|
      stories << iteration.stories
    end
    return stories.flatten
  end
  
  def to_s
    self.name
  end
  
  def info
    "#{self.name} <br/> #{self.stories.map(&:title).join(', ')}"
  end

end
