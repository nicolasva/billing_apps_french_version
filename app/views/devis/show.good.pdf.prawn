require 'prawn'
require 'prawn/layout'
require 'prawn/core'
pigs = "#{RAILS_ROOT}/public/images/img_logo_tharsis/logotharsis.jpg"
pdf.image pigs, :scale => 0.3
pdf.bounding_box [0,650], :width => 200  do
	pdf.text "Tharsis Software", :size => 15, :style => :bold
	pdf.text "15 rue Jean-Baptiste Berlier"
	pdf.text "75013 Paris"
	pdf.text "01 55 43 79 10"
	pdf.text "sales@tharsis-software.com"
	pdf.text "TVA FR64493029839"	
end

pdf.bounding_box [450, 550], :width => 100 do
	pdf.text @devi.client.namerefcontact
	pdf.text @devi.client.nameentreprise, :style => :bold
        pdf.text @devi.client.adresse
        pdf.text @devi.client.ville
end

pdf.bounding_box [0,450], :width => 200 do
pdf.text "Devis", :style => :bold
pdf.text "Numéro : #{@devi.numdevis}"
pdf.text "Date : #{@devi.created_at.strftime('%d-%m-%Y')}"
pdf.text "Numéro client : #{@devi.client.numclient}"
end

nb_items_comparate = 4
nb_items = 0
#pdf.bounding_box [0, 350], :width => 550 do 
        number_tab_produit = 350
	pdf.text "Description", :style => :bold
	pdf.text @devi.description.nil? ? "" : @devi.description, :style => :bold

	Information.all.each{|information|
 	    unless @devi.informationlignes.find(:first, :conditions=>{:information_id=>information.id}).nil?
		items = Array.new
		items_temp = Array.new
		#items.push([{:text => information.name, :colspan => 5}])
		@devi.informationlignes.find(:all, :conditions=>{:information_id=>information.id}).each{ |informationligne|
			informationligne.number.nil? && informationligne.price.nil? ? "" : @totalsumgeneral += informationligne.number * informationligne.price 
			items_temp.push((information.name.nil? ? "" : informationligne.name), informationligne.number, informationligne.unite, informationligne.price, (informationligne.number.nil? && informationligne.price.nil? ? "" : informationligne.number * informationligne.price))	
			items.push(items_temp)
			items_temp = Array.new
		}
		nb_items += items.length

		@hash_totalsnumgeneral[information.name] = @totalsumgeneral
		items.push([{:text => "Somme #{information.name}", :colspan => 4}, @totalsumgeneral])	
	    pdf.bounding_box [0, number_tab_produit], :width => 200 do	
		pdf.text information.name, :style => :bold
		#pdf.text items.length.to_s
		pdf.table items, :border_style => :grid, :position => :top, 
			:headers => ["Produit", "Nb", "Unité", "Prix €", "Total"],
			:align=> { 0 => :left, 1 => :left, 2 => :left, 3 => :left },
			:border_style => :underline_header,
			:width => 450 
		end
		@totalsumgeneral = 0
                if nb_items < nb_items_comparate
			number_tab_produit -= 100
		else
			number_tab_produit = 300
		end
            end
	}
	#pdf.text "Total"
	#items = Array.new
	#items_temp = Array.new
        #Information.all.each{ |information|
	#	unless @hash_totalsnumgeneral[information.name].nil?
	#		items.push(items_temp.push(information.name, @hash_totalsnumgeneral[information.name]))	
	#	end
	#	items_temp = Array.new
	#}

	#items += [["HT", @totalsumgeneral]]
	#items += [["TVA 19,6%", @totalsumgeneral * 0.196], ["TTC", (@totalsumgeneral * 0.196) + @totalsumgeneral]] if @devi.tva?

	

	#pdf.table items, :border_style => :grid,
	#	:headers => ["produit", "Total net €"],
	#	:align => {0 => :left, 1 => :left},
 	#	:border_style => :underline_header,
	#	:width => 450
#end


#pdf.span(450) do 
#	pdf.text "Validité de l'offre : 1 mois"

#	pdf.text "Tous travaux non cités en référence sur ce présent devis feront l'objet d'un avenant ou d'une facturation complémentaire"

#	pdf.text "Conditions de payment :"
#	pdf.text "#{@devi.cond_payment}"

#	pdf.text "Pour l'enregistrement de votre Commande :"
#	pdf.text "Nous vous prions de bien vouloir nous retourner :"
#	pdf.text "Un exemplaire de ce devis daté et signé avec la mention 'Bon pour accord' qui fera alors office de bon de commande."
#	pdf.text "Seules les commandes avec acompte sont fermes et définitives. Ce devis annule et remplace s'il y a lieu, le ou les précédents."
#end

#point = [0, pdf.bounds.bottom + 25]
#pdf.repeat :all do
#pdf.bounding_box(point, :width => 450) do
#    pdf.span(450, :position => :center) do
#	pdf.text "Tharsis Software - S.A.R.L. au capital de 10 500€"
#    end
#    pdf.span(450, :position => :center) do
#	pdf.text "RCS PARIS 493 029 839 - SIRET 493 029 839 00021 - TVA FR64493029839"
#    end
#end 
#end
