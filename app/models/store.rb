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
end
