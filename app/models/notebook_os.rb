# == Schema Information
# Schema version: 20100329102350
#
# Table name: notebook_os
#
#  id          :integer(4)      not null, primary key
#  notebook_id :integer(4)
#  os_id       :integer(4)
#

class NotebookOs < ActiveRecord::Base
end
