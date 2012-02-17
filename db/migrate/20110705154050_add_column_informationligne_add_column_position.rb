class AddColumnInformationligneAddColumnPosition < ActiveRecord::Migration
  def self.up
	  add_column(:informationlignes, :position, :integer)
  end
end
