class AddColumnDeviIdTitleinformationligneId < ActiveRecord::Migration
  def self.up
	  add_column :titleinformationlignes, :devi_id, :integer, :default=>0, :null=>false

	  add_index :titleinformationlignes, [:devi_id], :name=>"titleinformationlignes_devi_id"
	  add_index :titleinformationlignes, [:informationligne_id], :name=>"titleinformationlignes_informationligne_id"
  end
end
