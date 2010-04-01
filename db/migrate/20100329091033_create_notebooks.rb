class CreateNotebooks < ActiveRecord::Migration
  def self.up
    create_table :notebooks do |t|
      t.string :code,:null=>false, :unique=>true
      t.string :name
      t.string :mark
      t.string :processor_type
      t.integer :processor_freq
      t.integer :l2_cache
      t.float :display_diag
      t.integer :display_resolution_ver
      t.integer :display_resolution_hor
      t.string :memory_type
      t.integer :memory_capacity
      t.integer :memory_bus_freq
      t.integer :disc_capacity
      t.integer :disc_rotations
      t.boolean :webcam,:default => false
      t.integer :webcam_resolution_ver
      t.integer :webcam_resolution_hor
      t.integer :webcam_resolution_pixels
      t.string :network
      t.boolean :wifi,:default => false
      t.boolean :bluetooth,:default => false
      t.boolean :numeric_keyboard,:default => false
      t.float :weight
      t.integer :batery_cell_num
      t.float :batery_life_time
      t.float :size_x
      t.float :size_y
      t.float :size_z
      t.boolean :touchpad,:default => false
      t.boolean :trackpoint,:default => false
      t.boolean :modem,:default => false
      t.string :picture_link
      t.text :description
      t.string :drive
      t.string :grafic_card
    end
  end

  def self.down
    drop_table :notebooks
  end
end
