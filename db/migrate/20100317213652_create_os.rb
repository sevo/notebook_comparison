class CreateOs < ActiveRecord::Migration
  def self.up
    create_table :OS do |t|
      t.string :mark
      t.string :type
      t.string :version
    end

  end

  def self.down
    drop_table :OS
  end
end
