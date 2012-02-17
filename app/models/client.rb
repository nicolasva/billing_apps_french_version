class Client < ActiveRecord::Base
	validates_presence_of :numclient, :message=>"Numéro de client obligatoire"
	validates_presence_of :nameentreprise, :message=>"Nom de l'entreprise obligatoire"
	validates_presence_of :adresse, :message=>"Adresse obligatoire"
	has_many :devis
end
