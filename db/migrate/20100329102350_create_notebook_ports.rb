class CreateNotebookPorts < ActiveRecord::Migration
  def self.up
    create_table :notebook_ports do |t|
      t.integer :number
      t.references :notebook
      t.references :port
    end
  end

  def self.down
    drop_table :notebook_ports
  end
end
