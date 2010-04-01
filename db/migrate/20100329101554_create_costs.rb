class CreateCosts < ActiveRecord::Migration
  def self.up
    create_table :costs do |t|
      t.date :date
      t.float :cost_wdph
      t.references :store
      t.references :notebook
    end
  end

  def self.down
    drop_table :costs
  end
end
