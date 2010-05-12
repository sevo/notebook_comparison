# == Schema Information
# Schema version: 20100421200407
#
# Table name: notebooks
#
#  id                       :integer(4)      not null, primary key
#  code                     :string(255)     not null
#  name                     :string(255)
#  mark                     :string(255)
#  processor_type           :string(255)
#  processor_freq           :float
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
#  weight                   :string(255)
#  batery_cell_num          :integer(4)
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
#  batery_life_time         :string(255)
#  card_reader              :boolean(1)
#  OS                       :string(255)
#  monitor_out              :string(255)
#  USB_number               :integer(4)
#

class Notebook < ActiveRecord::Base
  has_many :costs, :dependent => :destroy
  has_many :notebook_ports, :dependent => :destroy
  has_many :notebook_stores, :dependent => :destroy
  has_many :notebook_card_types, :dependent => :destroy
  has_many :ports, :through => :notebook_ports
  has_many :stores, :through => :notebook_stores
  has_many :card_types, :through => :notebook_card_types

  def popis
    text =""
    text += name if name != nil
    text += "/ " + processor_freq.to_s+" GHz" if processor_freq != nil
    text += "/ " + display_diag.to_s+'"' if display_diag != nil
    text += "/ " + memory_capacity.to_s+"GB" if memory_capacity != nil
    text += "/ " + disc_capacity.to_s+"GB" if disc_capacity != nil
    text += "/ webcam" if webcam == true
    text += "/ bluetooth" if bluetooth == true
    text += "/ wifi" if wifi == true
    text += "/ " + network if network != nil
    text += "/ " + drive if drive != nil
    text
  end
end
