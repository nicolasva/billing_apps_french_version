module JavascriptHelper
	def getfacturepvrecetteapercu(facture)
	       get_facture_ttc(facture)

		"#{@total_facture_ht}-#{@total_facture_ttc}"
	end

	def getfacturepvrecetteapercutotal(factures)
	        factures.each{ |facture|
			get_facture_ttc(facture)
		}

		"#{@total_facture_ht}-#{@total_facture_ttc}"
	end
end
