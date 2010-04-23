# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100421200407) do

  create_table "card_types", :force => true do |t|
    t.string "type"
  end

  create_table "costs", :force => true do |t|
    t.date    "date"
    t.float   "cost_wdph"
    t.integer "store_id"
    t.integer "notebook_id"
  end

  create_table "notebook_card_types", :force => true do |t|
    t.integer "notebook_id"
    t.integer "card_type_id"
  end

  create_table "notebook_ports", :force => true do |t|
    t.integer "number"
    t.integer "notebook_id"
    t.integer "port_id"
  end

  create_table "notebook_stores", :force => true do |t|
    t.integer "cost_id"
    t.integer "notebook_id"
    t.integer "store_id"
  end

  create_table "notebooks", :force => true do |t|
    t.string  "code",                     :null => false
    t.string  "name"
    t.string  "mark"
    t.string  "processor_type"
    t.float   "processor_freq"
    t.integer "l2_cache"
    t.float   "display_diag"
    t.integer "display_resolution_ver"
    t.integer "display_resolution_hor"
    t.string  "memory_type"
    t.integer "memory_capacity"
    t.integer "memory_bus_freq"
    t.integer "disc_capacity"
    t.integer "disc_rotations"
    t.boolean "webcam"
    t.integer "webcam_resolution_ver"
    t.integer "webcam_resolution_hor"
    t.integer "webcam_resolution_pixels"
    t.string  "network"
    t.boolean "wifi"
    t.boolean "bluetooth"
    t.boolean "numeric_keyboard"
    t.string  "weight"
    t.integer "batery_cell_num"
    t.float   "size_x"
    t.float   "size_y"
    t.float   "size_z"
    t.boolean "touchpad"
    t.boolean "trackpoint"
    t.boolean "modem"
    t.string  "picture_link"
    t.text    "description"
    t.string  "drive"
    t.string  "grafic_card"
    t.string  "batery_life_time"
    t.boolean "card_reader"
    t.string  "OS"
    t.string  "monitor_out"
    t.integer "USB_number"
  end

  create_table "ports", :force => true do |t|
    t.string "type"
    t.string "name"
  end

  create_table "stores", :force => true do |t|
    t.string "name"
    t.string "link"
  end

end
