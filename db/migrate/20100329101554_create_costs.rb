class CreateCosts < ActiveRecord::Migration
  def self.up
    create_table :costs do |t|
      t.date :date
      t.float :cost_wdph
    end
  end

  def self.down
    drop_table :costs
  end
end
