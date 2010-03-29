class CreateCardType < ActiveRecord::Migration
  def self.up
    create_table :card_type do |t|
      t.string :type
    end
  end

  def self.down
    drop_table :card_type
  end
end
