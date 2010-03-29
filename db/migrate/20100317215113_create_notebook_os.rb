class CreateNotebookOs < ActiveRecord::Migration
  def self.up
    create_table :notebook_os do |t|
      t.references :notebook
      t.references :os
    end

  end

  def self.down
    drop_table :notebook-os
  end
end
