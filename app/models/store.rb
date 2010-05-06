# == Schema Information
# Schema version: 20100421200407
#
# Table name: stores
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#  link :string(255)
#

class Store < ActiveRecord::Base
  has_many :notebook_stores, :dependent => :destroy
  has_many :notebooks, :through => :notebook_stores
  has_many :costs, :through => :notebook_stores
end
