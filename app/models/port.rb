# == Schema Information
# Schema version: 20100421200407
#
# Table name: ports
#
#  id   :integer(4)      not null, primary key
#  type :string(255)
#

class Port < ActiveRecord::Base
  has_many :notebook_ports, :dependent => :destroy
  has_many :notebooks, :through => :notebook_ports
end
