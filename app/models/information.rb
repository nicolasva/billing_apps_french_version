class Information < ActiveRecord::Base
	self.table_name = "informations"
	validates_presence_of :name, :message=>"Nom obligatoire"
	has_many :informationlignes
	has_many :titleinformationlignes
	accepts_nested_attributes_for :titleinformationlignes, :informationlignes
end
