# == Schema Information
# Schema version: 20100421200407
#
# Table name: notebook_card_types
#
#  id           :integer(4)      not null, primary key
#  notebook_id  :integer(4)
#  card_type_id :integer(4)
#

class NotebookCardType < ActiveRecord::Base
end
