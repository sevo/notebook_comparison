class CreateNotebookPort < ActiveRecord::Migration
  def self.up
    create_table :notebook_port do |t|
      t.integer :number
      t.references :notebook
      t.references :port
    end
  end

  def self.down
    drop_table :notebook-port
  end
end
