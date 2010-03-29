class CreateNotebookCost < ActiveRecord::Migration
  def self.up
    create_table :notebook_cost do |t|
      t.references :notebook
      t.references :cost
    end

  end

  def self.down
    drop_table :notebook-cost
  end
end
