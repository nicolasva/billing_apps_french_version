class Informationligne < ActiveRecord::Base
	belongs_to :information
	belongs_to :devi
        has_many :titleinformationlignes
	accepts_nested_attributes_for :devi
	accepts_nested_attributes_for :titleinformationlignes
	accepts_nested_attributes_for :information

	validates_presence_of :number, :message=>"Veuillez saisir toutes les quantités"
	validates_presence_of :price, :message=>"Veuillez saisir tous les prix"
end
