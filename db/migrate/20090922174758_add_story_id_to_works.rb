class AddStoryIdToWorks < ActiveRecord::Migration
  def self.up
    add_column :works, :story_id, :integer
  end

  def self.down
    remove_column :works, :story_id
  end
end
