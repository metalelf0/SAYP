class CreateIterations < ActiveRecord::Migration
  def self.up
    create_table :iterations do |t|
      t.date :start_date
      t.date :end_date
      t.integer :project_id
      t.timestamps
    end
  end

  def self.down
    drop_table :iterations
  end
end
