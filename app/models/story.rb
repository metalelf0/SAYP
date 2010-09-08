class Story < ActiveRecord::Base

  has_many :works
  belongs_to :project
  belongs_to :iteration
  
    
  def total_pomodori_spent
    works.inject(0) { |total, work| total += work.pomodori }
  end
  
  def workers
    workers = Hash.new(0)
    works.each do |work| 
      work.users.each do |worker| 
        workers[worker.alias] += work.pomodori
      end
    end
    workers
  end
  
  def to_s
    self.title
  end
  
  def info
    "Story: #{self.title}<br/>#{self.workers.inspect}<br/>Pomodori totali: #{self.total_pomodori_spent}"
  end

  def project_name
    self.project ? self.project.name : nil
  end

end
