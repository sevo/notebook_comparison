class CreateStore < ActiveRecord::Migration
  def self.up
    create_table :store do |t|
      t.string :name
      t.text :email
      t.string :link
    end
  end

  def self.down
    drop_table :store
  end
end
