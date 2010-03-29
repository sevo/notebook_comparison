class CreatePort < ActiveRecord::Migration
  def self.up
    create_table :port do |t|
      t.string :type
    end
  end

  def self.down
    drop_table :port
  end
end
