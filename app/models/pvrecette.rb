class Pvrecette < ActiveRecord::Base
	validates_presence_of :numpvrecette, :message => "Numéro du PV de recette obligatoire"
	validates_presence_of :devi_id, :message => "Séléctionner un devis"
	belongs_to :devi
	accepts_nested_attributes_for :devi
        has_and_belongs_to_many :factures, :delete_sql=>"delete from factures_pvrecettes where pvrecette_id=#{self.id}"	
end
