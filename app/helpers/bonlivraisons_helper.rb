module BonlivraisonsHelper
	def total_ttc_bonlivraison(factures)
	      factures.each{ |facture|
		get_facture_ttc(facture)
	      }	

	      @total_facture_ttc
	end
end
