class AddColumnTitleinformationlignes < ActiveRecord::Migration
  def self.up
	  add_column :titleinformationlignes, :font_size, :float, :default=>10, :null=>false
  end
end
