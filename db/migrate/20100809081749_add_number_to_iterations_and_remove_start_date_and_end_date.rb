class AddNumberToIterationsAndRemoveStartDateAndEndDate < ActiveRecord::Migration
  def self.up
    add_column :iterations, :number, :integer
    remove_column :iterations, :start_date
    remove_column :iterations, :end_date
  end

  def self.down
    remove_column :iterations, :number
    add_column :iterations, :start_date, :date
    add_column :iterations, :end_date, :date
  end
end
