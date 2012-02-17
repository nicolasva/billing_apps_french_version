class Devi < ActiveRecord::Base
	belongs_to :client
	has_many :lignedevis, :dependent => :destroy
	has_many :factures, :dependent => :destroy
	has_many :informationlignes, :dependent => :destroy
	has_many :pvrecettes, :dependent => :destroy
	has_many :bonlivraisons, :dependent => :destroy
	accepts_nested_attributes_for :informationlignes, :factures, :lignedevis, :pvrecettes
	attr_accessor :devi_id_copy

	def set_copy_contenu_devi
		result = true
		informationlignes = Informationligne.where(:devi_id=>self.devi_id_copy).all
		informationlignes.each{ |informationligne|
			result = false unless set_informationlignes(informationligne.name,informationligne.number,informationligne.price,informationligne.information_id,informationligne.unite)
		}

		lignedevis = Lignedevi.where(:devi_id=>self.devi_id_copy).all
		lignedevis.each{ |lignedevi|
			result = false unless set_lignedevis(lignedevi.prix,lignedevi.name)
		}

		return result
	end

	private
	def set_lignedevis(prix,name)
		lignedevi = Lignedevi.new(:devi_id=>self.id, :prix=>prix, :name=>name)
		lignedevi.save
	end

	def set_informationlignes(name,number,price,information_id,unite)
		information = Informationligne.new(:name=>name, :number=>number, :price=>price, :devi_id=>self.id, :information_id=>information_id, :unite=>unite)
		information.save
	end
end
