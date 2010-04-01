# == Schema Information
# Schema version: 20100329102350
#
# Table name: stores
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#  link :string(255)
#

class Store < ActiveRecord::Base
end
