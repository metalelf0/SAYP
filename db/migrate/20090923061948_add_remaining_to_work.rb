class AddRemainingToWork < ActiveRecord::Migration
  def self.up
    add_column :works, :remaining, :integer
  end

  def self.down
    remove_column :works, :remaining
  end
end
