class Titleinformationligne < ActiveRecord::Base
	belongs_to :informationligne
	belongs_to :information
	accepts_nested_attributes_for :informationligne
	accepts_nested_attributes_for :information
      
        validates_presence_of :title, :message => "Veuillez entrer un titre afin de pouvoir continuer à enregistrer les informations concernant ce devis"
	validates_presence_of :font_size, :message =>"Veuillez entrer le taille pour ce titre"
	validates_presence_of :information_id 
end
