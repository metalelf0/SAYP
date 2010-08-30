class Iteration < ActiveRecord::Base
  
  has_many :stories
  belongs_to :project
  
  def info
    return self.inspect
  end

end
