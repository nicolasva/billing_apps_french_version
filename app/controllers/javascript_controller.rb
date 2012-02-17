class JavascriptController < ApplicationController
	def calculpvrecettes
    		@totalsumgeneral = 0
    		@hash_totalsnumgeneral = Hash.new
    		@total_facture_ht = params[:total_ht].to_f
    		@total_facture_ttc = params[:total_ttc].to_f
    		@total_facture_attente_paiement_ht = 0
    		@total_facture_attente_paiement_ttc = 0 
    		@total_facture_paiement_ht = 0
    		@total_facture_paiement_ttc = 0
    		@facture = Facture.find(params[:facture_id])
	end

	def calculpvrecettestotal	
    		@totalsumgeneral = 0
    		@hash_totalsnumgeneral = Hash.new
    		@total_facture_ht = 0
    		@total_facture_ttc = 0
    		@total_facture_attente_paiement_ht = 0
    		@total_facture_attente_paiement_ttc = 0 
    		@total_facture_paiement_ht = 0
    		@total_facture_paiement_ttc = 0
    		@factures = Facture.where(:id=>params[:facture_id].split("-")).all
	end

	def list_informationlignedevis
		@total_facture_ht = 0
		@total_facture_ttc = 0
   		@total_facture_attente_paiement_ht = 0
   		@total_facture_attente_paiement_ttc = 0
		@total_facture_paiement_ht = 0
		@total_facture_paiement_ttc = 0
		list_id_facture = params[:facture_id]
		array_id_facture = Array.new
		array_id_facture = list_id_facture.split("-")
		@factures = Facture.where(:id=>array_id_facture)
		#render :text => "<tr><td>test nicolas</td></tr>"
	end

	def sortable_titleinformationligne_to_informationligne
		informationligne_id = params[:informationligne_id].to_i
		titleinformationligne_id = params[:titleinformationligne_id].to_i
		devi_id = params[:devi_id].to_i

	 	titleinformationligne = Titleinformationligne.find(titleinformationligne_id.to_i)

		render :text=>titleinformationligne.update_attributes(:informationligne_id=>informationligne_id)
		#<label for="devi_informationlignes_attributes_0_titleinformationlignes_attributes_0_title">Titre</label><br>
		#										<input id="devi_informationlignes_attributes_0_titleinformationlignes_attributes_0_title" name="devi[informationlignes_attributes][0][titleinformationlignes_attributes][0][title]" size="30" type="text" value="title by default" />
		#										</li><input id="devi_informationlignes_attributes_0_titleinformationlignes_attributes_0_id" name="devi[informationlignes_attributes][0][titleinformationlignes_attributes][0][id]" type="hidden" value="24" />
	end
end
