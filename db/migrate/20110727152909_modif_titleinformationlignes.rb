class ModifTitleinformationlignes < ActiveRecord::Migration
  def self.up
	  add_column :titleinformationlignes, :information_id, :integer, :default=>0, :null=>false
	  change_column :titleinformationlignes, :informationligne_id, :integer, :null=>true

	  add_index "titleinformationlignes", ["information_id"], :name => "titleinformationlignes_information_id"
  end
end
