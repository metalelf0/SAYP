class CreateUsersWorks < ActiveRecord::Migration
  def self.up
    create_table :users_works, :id => false do |t|
      t.references :user
      t.references :work
      t.timestamps
    end
  end

  def self.down
    drop_table :users_works
  end
end
