# == Schema Information
# Schema version: 20100421200407
#
# Table name: costs
#
#  id          :integer(4)      not null, primary key
#  date        :date
#  cost_wdph   :float
#  store_id    :integer(4)
#  notebook_id :integer(4)
#

class Cost < ActiveRecord::Base
  belongs_to :notebook
  belongs_to :store
  has_many :notebooks, :through => :notebook_stores
  has_many :stores, :through => :notebook_stores
end
