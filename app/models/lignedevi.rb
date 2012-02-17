class Lignedevi < ActiveRecord::Base
	belongs_to :devi
	accepts_nested_attributes_for :devi

	validates_presence_of :prix, :message=>"Vauillez saisir le prix"
end
