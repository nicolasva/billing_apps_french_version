class AddTableTitleinformationlignes < ActiveRecord::Migration
  def self.up
  create_table "titleinformationlignes", :force => true do |t|
    t.string   "title",                                     :null => false
    t.integer  "informationligne_id", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "information_id",      :default => 0,        :null => false
    t.integer  "devi_id",             :default => 0,        :null => false
    t.float    "font_size",           :default => 10.0,     :null => false
    t.string   "font_weight",         :default => "normal", :null => false
  end

  	add_index "titleinformationlignes", ["devi_id"], :name => "titleinformationlignes_devi_id"
  	add_index "titleinformationlignes", ["information_id"], :name => "altered_titleinformationlignes_information_id"
  	add_index "titleinformationlignes", ["informationligne_id"], :name => "titleinformationlignes_informationligne_id"
  end

  def self.down
  end
end
