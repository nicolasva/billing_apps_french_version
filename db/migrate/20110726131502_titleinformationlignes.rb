class Titleinformationlignes < ActiveRecord::Migration
  def self.up
	create_table "titleinformationlignes", :force => true do |t|
	     t.string "title", :null=>false
	     t.integer "informationligne_id", :null=>false
	     t.timestamps
	end
  end
end
