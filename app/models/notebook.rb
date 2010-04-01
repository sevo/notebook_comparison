# == Schema Information
# Schema version: 20100329102350
#
# Table name: notebooks
#
#  id                       :integer(4)      not null, primary key
#  code                     :string(255)     not null
#  name                     :string(255)
#  mark                     :string(255)
#  processor_type           :string(255)
#  processor_freq           :integer(4)
#  l2_cache                 :integer(4)
#  display_diag             :float
#  display_resolution_ver   :integer(4)
#  display_resolution_hor   :integer(4)
#  memory_type              :string(255)
#  memory_capacity          :integer(4)
#  memory_bus_freq          :integer(4)
#  disc_capacity            :integer(4)
#  disc_rotations           :integer(4)
#  webcam                   :boolean(1)
#  webcam_resolution_ver    :integer(4)
#  webcam_resolution_hor    :integer(4)
#  webcam_resolution_pixels :integer(4)
#  network                  :string(255)
#  wifi                     :boolean(1)
#  bluetooth                :boolean(1)
#  numeric_keyboard         :boolean(1)
#  weight                   :float
#  batery_cell_num          :integer(4)
#  batery_life_time         :float
#  size_x                   :float
#  size_y                   :float
#  size_z                   :float
#  touchpad                 :boolean(1)
#  trackpoint               :boolean(1)
#  modem                    :boolean(1)
#  picture_link             :string(255)
#  description              :text
#  drive                    :string(255)
#  grafic_card              :string(255)
#

class Notebook < ActiveRecord::Base
end