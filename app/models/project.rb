class Project < ActiveRecord::Base
  
  has_many :stories
  has_many :iterations
  
  def Project.create_with_iteration project_name
    return nil if Project.find_by_name(project_name)
    project = Project.create(:name => project_name)
    project.add_iteration_for(Date.today)
    project.save
    project
  end
  
  def add_iteration_for date   # TODO: remove this date param, its not used
    self.iterations << Iteration.create
    self.save
  end

  def stories
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
