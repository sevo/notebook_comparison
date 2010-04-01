class CreateNotebookStores < ActiveRecord::Migration
  def self.up
    create_table :notebook_stores do |t|
      t.references :cost
      t.references :notebook
      t.references :store
    end
  end

  def self.down
    drop_table :notebook_stores
  end
end
