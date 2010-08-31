class Iteration < ActiveRecord::Base

  validates_uniqueness_of :number, :scope => :project_id
  
  has_many :stories
  belongs_to :project
  
  def info
    return self.inspect
  end

end
