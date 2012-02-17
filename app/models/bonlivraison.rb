class Bonlivraison < ActiveRecord::Base
	validates_presence_of :numlivraison, :message => "Numéro du bon de livraison obligatoire"
	validates_presence_of :devi_id, :message => "Numéro du devi obligatoire"
	has_and_belongs_to_many :factures, :delete_sql=>"delete from bonlivraisons_factures where bonlivraison_id=#{self.id}"
	belongs_to :devi
end
