class CreateNotebookCardType < ActiveRecord::Migration
  def self.up
    create_table :notebook_card_type do |t|
      t.references :notebook
      t.references :card_type
    end

  end

  def self.down
    drop_table :notebook-card_type
  end
end
