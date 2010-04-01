# == Schema Information
# Schema version: 20100329102350
#
# Table name: notebook_stores
#
#  id          :integer(4)      not null, primary key
#  cost_wdph   :float
#  notebook_id :integer(4)
#  store_id    :integer(4)
#

class NotebookStore < ActiveRecord::Base
end
