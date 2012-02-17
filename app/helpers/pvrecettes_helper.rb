module PvrecettesHelper
	def get_pvrecette_ttc(factures)
		factures.each{ |facture|
			get_facture_ttc(facture)
		}

		[@total_facture_ttc, @total_facture_ht]
	end

	def all_facture_check?(pvrecette)
		result = true
		pvrecette.devi.factures.all.collect { |facture|
			
			result = false unless pvrecette.factures.include?(facture) 
		}

		return result
	end
end
