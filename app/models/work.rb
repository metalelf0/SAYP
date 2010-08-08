class Work < ActiveRecord::Base
  
  belongs_to :story
  has_and_belongs_to_many :users

end
