#require 'prawn'
#require 'prawn/layout'
#require 'prawn/core'
#pigs = "#{RAILS_ROOT}/public/images/img_logo_tharsis/logotharsis.jpg"
#pdf.image pigs, :scale => 0.2
pdf.bounding_box [0,670], :width => 200  do
	pdf.text "Emeraude composites", :size => 13, :style => :bold
	pdf.text "24 bis rue de la truite", :size => 10
	pdf.text "22400 Coëtmieux", :size => 10
	pdf.text "06 76 54 41 94", :size => 10
	pdf.text "yann@emeraudecomposites.fr", :size => 10
	#pdf.text "\n"
  #      pdf.text "S.A.R.L. au capital de 10500€", :size => 10
	pdf.text "RM 22 803 795 301", :size => 10
	pdf.text "Siret 803 795 000 16", :size => 10
	#pdf.text "TVA FR64493029839", :size => 10	
end

#compteur_old = 28
#compteur_init = 28
pdf.bounding_box [320, 620], :width => 200 do
	pdf.text @devi.client.namerefcontact, :size => 10
	pdf.text @devi.client.nameentreprise, :style => :bold, :size => 10
        #pdf.text @devi.client.adresse, :size => 10
	@devi.client.adresse.each_line{ |line|
		#compteur_init += 1 
		pdf.text line, :size => 10	
	}
	pdf.text @devi.client.tva_intra, :size => 10 unless @devi.client.tva_intra.empty? && @devi.client.tva_intra.nil?
end


pdf.bounding_box [0,500], :width => 200 do
pdf.text "DEVIS", :style => :bold, :size => 10
pdf.text "Numéro : #{@devi.numdevis}", :size => 10
pdf.text "Date : #{@devi.created_at.strftime('%d/%m/%Y')}", :size => 10
pdf.text "Numéro client : #{@devi.client.numclient}", :size => 10
end

pdf.text "\n\n"

#pdf.bounding_box [0, 350], :width => 550 do 
	pdf.text "Description", :style => :bold, :size => 10
	unless @devi.description.nil?
		@devi.description.each_line{ |line|
			#compteur_init += 1
			pdf.text line, :size => 10
		}
	end

  headers = Array.new 
  headers.push("Produit")
  headers.push("Nb")
  headers.push("Unité")
  headers.push("Prix €")
  headers.push("Total €")
	Information.all.each do |information|
 	    unless @devi.informationlignes.find(:first, :conditions=>{:information_id=>information.id}).nil?
		items = Array.new
    items.push(headers)
		items_temp = Array.new
		#items.push([{:text => information.name, :colspan => 5}])
		@devi.informationlignes.find(:all, :conditions=>{:information_id=>information.id}, :order => "position").each{ |informationligne|
			#items.push([Prawn::Table::Cell.new(:width=>20, :text=>"nicolas", :font_size=>10)]) unless informationligne.titleinformationligne.nil?
			informationligne.number.nil? && informationligne.price.nil? ? "" : @totalsumgeneral += informationligne.number * informationligne.price 
			#items_temp.push((information.name.nil? ? "" : Prawn::Table::Cell.new(pdf, :width=>0,:text=>informationligne.name, :font_size=>10)), Prawn::Table::Cell.new(pdf, :width=>0, :text=>informationligne.number.to_s,:font_size=>10), Prawn::Table::Cell.new(pdf ,:text=>informationligne.unite.to_s,:width=>0,:font_size=>10), Prawn::Table::Cell.new(pdf, :text=>format("%.2f",informationligne.price).to_s, :width=>0,:font_size=>10), (informationligne.number.nil? && informationligne.price.nil? ? "" : Prawn::Table::Cell.new(pdf, :text=>(format("%.2f",informationligne.number * informationligne.price)).to_s, :width=>0, :font_size=>10)))	

			items_temp.push((information.name.nil? ? "" : informationligne.name), 
      informationligne.number.to_s, 
      informationligne.unite.to_s, 
      format("%.2f",informationligne.price).to_s, 
      (informationligne.number.nil? && informationligne.price.nil? ? "" : (format("%.2f",informationligne.number * informationligne.price)).to_s
      ))	
		
		     unless informationligne.titleinformationlignes.empty?	
			informationligne.titleinformationlignes.each{ |titleinformationligne|
				#items.push([Prawn::Table::Cell.new(pdf, :width=>20, :document => self, :border_width => 0, :borders => [:left], :text=>titleinformationligne.title, :font_style => titleinformationligne.font_weight == "bold" ? :bold : :normal, :font_size=>titleinformationligne.font_size), Prawn::Table::Cell.new(pdf, :width=>20, :document => self, :borders => [:none], :text=>""), Prawn::Table::Cell.new(pdf, :width=>20, :document => self, :borders => [:none], :text=>""), Prawn::Table::Cell.new(pdf, :width=>20, :document => self, :borders => [:none], :text=>""), Prawn::Table::Cell.new(pdf, :width=>20, :document => self, :borders => [:right], :text=>"")])
			  
				items.push([titleinformationligne.title, "", "", "", ""])
      }
                     end
			items.push(items_temp)
			items_temp = Array.new
		}


    #headers = [Prawn::Table::Cell.new(pdf,
    #:width => 0,
    #:text => "Produit",
    #:font_style => :bold,
    #:font_size => 10), Prawn::Table::Cell.new(pdf,
    #:width => 0,
    #:text => "Nb",
    #:font_style => :bold,
    #:font_size => 10), Prawn::Table::Cell.new(pdf,
    #:width => 0,
    #:text => "Unité",
    #:font_style => :bold,
    #:font_size => 10), Prawn::Table::Cell.new(pdf,
    #:width => 0,
    #:text => "Prix €",
    #:font_style => :bold,
    #:font_size => 10), Prawn::Table::Cell.new(pdf,
    #:width => 0,
    #:text => "Total €",
    #:font_style => :bold,
    #:font_size => 10)] 	
   
    pdf.text "\n\n"
		@hash_totalsnumgeneral[information.name] = @totalsumgeneral
		#phrase_somme = Prawn::Table::Cell.new(pdf, :text => "Somme #{information.name}", :document => self, :font_size => 10, :font_style => :bold)
		#totalsumgeneral = Prawn::Table::Cell.new(pdf, :text => format("%.2f",@totalsumgeneral).to_s, :document => self, :font_size => 10, :font_style => :bold)
		
    #items.push([phrase_somme,"","", "", totalsumgeneral])
		pdf.text information.name, :style => :bold, :font_size => 10
		#pdf.text items.length.to_s
		#Prawn::Table(pdf, items)
    pdf.table(items, :cell_style => { :borders => [:left, :right] })
    #  :border_style => :grid, 
		#	:headers => headers,
	 	#	:column_widths => {0 => 270},
		#	:align => { 0 => :left, 1 => :right, 2 => :right, 3 => :right, 4 => :right },
		#	:width => 535
		#end

		@totalsumgeneral = 0
	
  end

  headers_bis = Array.new
  headers_bis.push("Produit") 
  headers_bis.push("Total net €")
	
	pdf.text "\n\nTotal", :style => :bold, :size => 10
	items = Array.new
  items.push(headers_bis)
	items_temp = Array.new
        Information.all.each{ |information|
		unless @hash_totalsnumgeneral[information.name].nil?
			#items.push(items_temp.push(Prawn::Table::Cell.new(pdf, :text => information.name, :width => 0, :font_size=>10), Prawn::Table::Cell.new(pdf, :text=>@hash_totalsnumgeneral[information.name], :width=>0, :font_size=>10)))		
			items.push(items_temp.push(information.name, @hash_totalsnumgeneral[information.name]))	
      @totalsumgeneral += @hash_totalsnumgeneral[information.name]
		end
		items_temp = Array.new
	}

   #total = [[Prawn::Table::Cell.new(pdf,
   # :text => "Total", :document => self, :font_style => :bold, :font_size => 10),
	 #  Prawn::Table::Cell.new(pdf,
   # :text => format("%.2f",@totalsumgeneral).to_s, :document => self, :font_style => :bold, :font_size => 10)]]
	  

   total = [["Total", format("%.2f",@totalsumgeneral).to_s]]
   unless @devi.lignedevis.empty?
	totallignedevis = Array.new
   	@devi.lignedevis.each{ |lignedevi|
		@totalsumgeneral += lignedevi.prix
		totallignedevis.push([lignedevi.name,format("%.2f", lignedevi.prix).to_s])  
   	}
    totallignedevis.push(["HT",@totalsumgeneral.to_s])
   end
 
   tva = [["TVA 20%", 
	  format("%.2f",@totalsumgeneral * 0.2).to_s],
	  ["TTC", format("%.2f" , (@totalsumgeneral * 0.2) + @totalsumgeneral).to_s
		]]
	items += total
        items += totallignedevis unless @devi.lignedevis.empty?
	items += tva if @devi.tva?
	

  pdf.table(items, :cell_style => { :borders => [:left, :right] })
	#pdf.table(items, :border_style => :grid,
	#  :headers => headers_bis,
#		:column_widths => {0 => 430},
#		:align => {0 => :left, 1 => :right},
#		:width => 535)

#end
	pdf.text "\n\nValidité de l'offre : 1 mois\n\n", :size => 8

	pdf.text "Tous travaux non cités en référence sur ce présent devis feront l'objet d'un avenant ou d'une facturation complémentaire.\n\n", :size => 8

	pdf.text "Conditions de paiement :", :style => :bold, :size => 8
	pdf.text "#{@devi.cond_payment}\n\n", :size => 8

	pdf.text "Pour l'enregistrement de votre Commande :", :style => :bold, :size => 8
	pdf.text "Nous vous prions de bien vouloir nous retourner :", :size => 8
	pdf.text "Un exemplaire de ce devis daté et signé avec la mention 'Bon pour accord' qui fera alors office de bon de commande.", :size => 8
	pdf.text "Seules les commandes avec acompte sont fermes et définitives. Ce devis annule et remplace s'il y a lieu, le ou les précédents.", :size => 8

#pdf.number_pages "<page>/<total>", [pdf.bounds.right, 0]
end
