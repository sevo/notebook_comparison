# == Schema Information
# Schema version: 20100329102350
#
# Table name: notebook_ports
#
#  id          :integer(4)      not null, primary key
#  number      :integer(4)
#  notebook_id :integer(4)
#  port_id     :integer(4)
#

class NotebookPort < ActiveRecord::Base
end
