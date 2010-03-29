class CreateNotebookCosts < ActiveRecord::Migration
  def self.up
    create_table :notebook_costs do |t|
      t.references :notebook
      t.references :cost
    end
  end

  def self.down
    drop_table :notebook_costs
  end
end
