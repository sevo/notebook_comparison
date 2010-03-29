class CreateCost < ActiveRecord::Migration
  def self.up
    create_table :cost do |t|
      t.date :date
      t.float :cost_wdph
    end
  end

  def self.down
    drop_table :cost
  end
end
