# == Schema Information
# Schema version: 20100421200407
#
# Table name: notebook_stores
#
#  id          :integer(4)      not null, primary key
#  cost_id     :integer(4)
#  notebook_id :integer(4)
#  store_id    :integer(4)
#

class NotebookStore < ActiveRecord::Base
end
