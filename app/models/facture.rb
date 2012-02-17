class Facture < ActiveRecord::Base
	validates_presence_of :numfacture, :message => "Numéro de facture obligatoire"
	belongs_to :devi
	accepts_nested_attributes_for :devi	
        has_and_belongs_to_many :pvrecettes
	has_and_belongs_to_many :bonlivraisons, :delete_sql=>"delete from bonlivraisons_factures where facture_id=#{self.id}"
	has_many :avoirs, :dependent => :destroy

	def self.deleteTemporaryFile
		system("rm -r #{RAILS_ROOT}/public/factures/*")
	end
end
