# == Schema Information
# Schema version: 20100421200407
#
# Table name: card_types
#
#  id   :integer(4)      not null, primary key
#  type :string(255)
#

class CardType < ActiveRecord::Base
  has_many :notebook_card_types, :dependent => :destroy
  has_many :notebook, :through => :notebook_card_types
end
