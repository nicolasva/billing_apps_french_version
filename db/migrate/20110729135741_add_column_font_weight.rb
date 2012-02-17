class AddColumnFontWeight < ActiveRecord::Migration
  def self.up
	  add_column :titleinformationlignes, :font_weight, :string, :default=>"normal", :null=>false
  end
end
