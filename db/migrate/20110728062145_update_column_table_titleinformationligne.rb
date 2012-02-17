class UpdateColumnTableTitleinformationligne < ActiveRecord::Migration
  def self.up
	  change_column :titleinformationlignes, :informationligne_id, :integer, :default=>0, :null=>true
	  change_column :titleinformationlignes, :information_id, :integer, :null=>false
  end
end
