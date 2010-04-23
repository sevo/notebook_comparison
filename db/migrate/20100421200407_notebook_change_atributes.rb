class NotebookChangeAtributes < ActiveRecord::Migration
  def self.up
    change_table :notebooks do |t|
      t.remove :batery_life_time
      t.boolean :card_reader, :default => false
      t.string :OS
      t.string :monitor_out
      t.string :batery_life_time
      t.integer :USB_number
      
    end
  end

  def self.down
    change_table :notebooks do |t|
      t.remove :batery_life_time
      t.remove :card_reader
      t.remove :OS
      t.remove :monitor_out
      t.float :batery_life_time
      t.remove :USB_number

    end
  end
end
