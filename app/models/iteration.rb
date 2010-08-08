class Iteration < ActiveRecord::Base
  
  has_many :stories
  belongs_to :project
  
end
