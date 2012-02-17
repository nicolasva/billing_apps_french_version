require 'prawn'
require 'prawn/layout'
require 'prawn/core'

pigs = "#{RAILS_ROOT}/public/images/img_logo_tharsis/logotharsis.jpg"

pdf.image pigs, :scale => 0.2
pdf.bounding_box [0,670], :width => 200  do
	pdf.text "Tharsis Software", :size => 13, :style => :bold
	pdf.text "15 rue Jean-Baptiste Berlier", :size => 10
	pdf.text "75013 Paris", :size => 10
	pdf.text "01 55 43 79 10", :size=> 10
	pdf.text "billing@tharsis-software.com", :size => 10
	pdf.text "\n"
        pdf.text "S.A.R.L. au capital de 10500€", :size => 10
	pdf.text "RCS Paris 493 029 839", :size => 10
	pdf.text "Siret 493 029 839 00021", :size => 10
	pdf.text "TVA FR64493029839", :size => 10	
end
#compteur_old = 28 
compteur_init = 28
pdf.bounding_box [320, 620], :width => 200 do
	pdf.text @facture.devi.client.namerefcontact, :size => 10
	pdf.text @facture.devi.client.nameentreprise, :style => :bold, :size => 10
	@facture.devi.client.adresse.each_line{ |line|
		compteur_init += 1 
		pdf.text line, :size => 10
	}
	pdf.text @facture.devi.client.tva_intra, :size => 10 unless @facture.devi.client.tva_intra.empty? && @facture.devi.client.tva_intra.nil? 
end

	if compteur_init > 50
		compteur_init = 0
	end


pdf.bounding_box [0,500], :width => 200 do
	pdf.text "FACTURE #{@facture.proforma ? "PRO FORMA" : ""}", :style => :bold, :size => 10
	pdf.text "Numéro : #{@facture.numfacture}", :size => 10
	pdf.text "Date : #{@facture.created_at.strftime('%d/%m/%Y')}", :size => 10
        pdf.text "Devis : #{@facture.devi.numdevis}", :size => 10
	pdf.text "Numéro client : #{@facture.devi.client.numclient}", :size => 10
        #pdf.text("Commande : #{@facture.numcommande}", :size => 10) unless @facture.numcommande.nil? || @facture.numcommande.empty?
	unless @facture.numcommande.nil? || @facture.numcommande.empty?
		@facture.numcommande.each_line{ |line|
			compteur_init += 1
			pdf.text line, :size => 10
		}	
	end
end

	if compteur_init > 50
		compteur_init = 0
	end

pdf.text "\n\n"
	pdf.text "Description", :style => :bold, :size => 10
	#pdf.text((@facture.devi.description.nil? ? "" : @facture.devi.description), :size => 10)
	unless @facture.devi.description.nil?
		@facture.devi.description.each_line{ |line|
			compteur_init += 1
			pdf.text line, :size => 10
		}
	end

	Information.all.each{ |information|
		compteur_init += 1
        	unless @facture.devi.informationlignes.find(:first, :conditions=>{:information_id=>information.id}).nil?
			items = Array.new
			items_temp = Array.new
			unless information.name.nil?
				information.name.each_line{ |line|
					compteur_init += 1
				}
			end

 			@facture.devi.informationlignes.find(:all, :conditions=>{:information_id=>information.id}, :order => "position").each{ |informationligne|
				informationligne.number.nil? && informationligne.price.nil? ? "" : @totalsumgeneral += informationligne.number * informationligne.price
				items_temp.push((information.name.nil? ? "" : Prawn::Table::Cell.new(:width=>0, :text=>informationligne.name, :font_size=>10)), Prawn::Table::Cell.new(:text=>informationligne.number, :font_size=>10, :width=>0), Prawn::Table::Cell.new(:text=>informationligne.unite, :font_size=>10, :width=>0), Prawn::Table::Cell.new(:text=>format("%.2f",informationligne.price).to_s, :font_size=>10, :width=>0), (informationligne.number.nil? && informationligne.price.nil? ? "" : Prawn::Table::Cell.new(:text=>(format("%.2f",informationligne.number * informationligne.price)).to_s, :width=>0, :font_size=>10)))
				
		     unless informationligne.titleinformationlignes.empty?	
			informationligne.titleinformationlignes.each{ |titleinformationligne|
				items.push([Prawn::Table::Cell.new(:width=>20, :document => self, :border_width => 0, :borders => [:left], :text=>titleinformationligne.title, :font_style => titleinformationligne.font_weight == "bold" ? :bold : :normal, :font_size=>titleinformationligne.font_size), Prawn::Table::Cell.new(:width=>20, :document => self, :borders => [:none], :text=>""), Prawn::Table::Cell.new(:width=>20, :document => self, :borders => [:none], :text=>""), Prawn::Table::Cell.new(:width=>20, :document => self, :borders => [:none], :text=>""), Prawn::Table::Cell.new(:width=>20, :document => self, :borders => [:right], :text=>"")])
			}
                     end

				items.push(items_temp)
				items_temp = Array.new
				compteur_init += 1
			}

		

		#pdf.text compteur_init.to_s
		#pdf.text compteur_old.to_s
		#if (compteur_init > 40 || (compteur_init + compteur_old) > 40) && (compteur_old != 28 || compteur_init < 40)
                #      if compteur_init > 40
		#	dif_compteur = (50 - compteur_old) + 10
		#      else
		#	dif_compteur = (50 - (compteur_old + compteur_init)) + 20
		#      end
		#	0.upto(dif_compteur){ |i|
		#		pdf.text "\n"			
		#	}
		#	compteur_init = compteur_init - compteur_old
		#else
			pdf.text "\n\n"
		#end

		if compteur_init > 50
			compteur_init = 0
		end

    		headers = [Prawn::Table::Cell.new(
    		:width => 0,
    		:text => "Produit",
    		:font_style => :bold,
    		:font_size => 10), Prawn::Table::Cell.new(
    		:width => 0,
    		:text => "Nb",
    		:font_style => :bold,
    		:font_size => 10), Prawn::Table::Cell.new(
    		:width => 0,
    		:text => "Unité",
    		:font_style => :bold,
    		:font_size => 10), Prawn::Table::Cell.new(
    		:width => 0,
    		:text => "Prix €",
    		:font_style => :bold,
    		:font_size => 10), Prawn::Table::Cell.new(
    		:width => 0,
    		:text => "Total €",
    		:font_style => :bold,
    		:font_size => 10)] 

		@hash_totalsnumgeneral[information.name] = @totalsumgeneral
		phrase_somme = Prawn::Table::Cell.new(:text => "Somme #{information.name}", :document => self, :font_style => :bold, :font_size=>10)
		totalsumgeneral = Prawn::Table::Cell.new(:text => format("%.2f", @totalsumgeneral).to_s, :document => self, :font_style => :bold, :font_size=>10)
		items.push([phrase_somme, "", "", "", totalsumgeneral])
		pdf.text information.name, :style => :bold
		pdf.table items, :border_style => :grid,
			:headers => headers,
			:column_widths => {0 => 270},
			:align => {0 => :left, 1 => :right, 2 => :right, 3 => :right, 4 => :right },
			:width=> 535
		end
		@totalsumgeneral = 0
		#compteur_old = compteur_init
	}

	#pdf.text compteur_init.to_s
	#pdf.text compteur_old.to_s
	#if compteur_init  > 19 && compteur_old != 28
	#	dif_compteur = ((compteur_old + compteur_init) > 28 && (compteur_old + compteur_init) < 51) ? 5 : (50 - compteur_init)
	#	0.upto(dif_compteur){ |i|
	#		pdf.text "\n"			
	#	}
	#		compteur_init = 0
	#else
	pdf.text "\n\n"
	#end

	if compteur_init > 50
		compteur_init = 0
	end

	pdf.text "Total", :style => :bold, :font_size=>10
	items = Array.new
	items_temp = Array.new
	Information.all.each{ |information|
		unless @hash_totalsnumgeneral[information.name].nil?
			items.push(items_temp.push(Prawn::Table::Cell.new(:text=>information.name.nil? ? "" : information.name, :width => 0, :font_size=>10), Prawn::Table::Cell.new(:text=>@hash_totalsnumgeneral[information.name], :width => 0, :font_size=>10)))
			@totalsumgeneral += @hash_totalsnumgeneral[information.name]
		end
		items_temp = Array.new
	}
 
   total = [[Prawn::Table::Cell.new(
    :text => "Total #{@facture.devi.tva ? "" : "*"}", :document => self, :font_style => (@facture.accompte == 100 ? :bold : :normal), :font_size=>10),
	   Prawn::Table::Cell.new(
    :text => format("%.2f",@totalsumgeneral).to_s, :document => self, :font_style => (@facture.accompte == 100 ? :bold : :normal), :font_size=>10)]]
 
     unless @facture.devi.lignedevis.empty?
    	totallignedevis = Array.new
	@facture.devi.lignedevis.each{ |lignedevi| 
		@totalsumgeneral += lignedevi.prix
		totallignedevis.push([Prawn::Table::Cell.new(:text=>lignedevi.name, :font_style => :normal, :font_size => 10),Prawn::Table::Cell.new(:text=>format("%.2f", lignedevi.prix).to_s, :font_style => :normal, :font_size => 10)])  
	}
	totallignedevis.push([Prawn::Table::Cell.new(:text=>"HT", :font_style => @facture.accompte == 100 ? :bold : :normal, :font_size => 10),Prawn::Table::Cell.new(:text=>@totalsumgeneral.to_s, :font_style => @facture.accompte == 100 ? :bold : :normal, :font_size => 10)])
     end 
  if @facture.accompte == 100 
   tva = [[Prawn::Table::Cell.new(
    :text => "TVA 19,6%", :document => self, :font_style => :bold, :font_size=>10), 
	  Prawn::Table::Cell.new(
    :text => format("%.2f",@totalsumgeneral * 0.196).to_s, :document => self, :font_style => :bold, :font_size=>10)],
	  [Prawn::Table::Cell.new(
    :text => "TTC", :document => self, :font_size=>10, :font_style => :bold), Prawn::Table::Cell.new(
    :text => format("%.2f",(@totalsumgeneral * 0.196) + @totalsumgeneral).to_s, :document => self, :font_style => :bold, :font_size=>10)
		]]
   else	 
        total_accompte = [[Prawn::Table::Cell.new(:text=>"HT (#{@facture.accompte}%)", :document => self, :font_style => :bold, :font_size=>10), Prawn::Table::Cell.new(:text=>(format("%.2f",(@totalsumgeneral*@facture.accompte)/100)).to_s, :document => self, :font_style => :bold, :font_size=>10)]]

	tva = [[Prawn::Table::Cell.new(:text=>"TVA 19,6%", :document => self, :font_style => :bold, :font_size=>10), Prawn::Table::Cell.new(:text=>format("%.2f",(((@totalsumgeneral*@facture.accompte)/100)*19.6)/100).to_s, :document => self, :font_style => :bold, :font_size => 10)]]

	ttc = [[Prawn::Table::Cell.new(:text=>"TTC", :document => self, :font_style => :bold, :font_size=>10), Prawn::Table::Cell.new(:text=>(format("%.2f",(((@totalsumgeneral*@facture.accompte)/100)*0.196)+((@totalsumgeneral*@facture.accompte)/100))).to_s, :document => self, :font_style => :bold, :font_size=>10)]]
        tva += ttc 
   end
	items += total
	items += totallignedevis unless @facture.devi.lignedevis.empty?
        items += total_accompte unless @facture.accompte == 100
	items += tva if @facture.devi.tva?
    header_bis = [Prawn::Table::Cell.new(:position => [0,0],
    :width => 0,
    :text => "Produit",
    :font_style => :bold,
    :font_size => 10),Prawn::Table::Cell.new(:position => [0,0],
    :width => 0,
    :text => "Total net €",
    :font_style => :bold,
    :font_size => 10)]

    	pdf.table(items, :border_style => :grid,
		:headers => header_bis,
		:column_widths => {0 => 430},
		:align => {0 => :left, 1 => :right},
		:width => 535)


	#compteur_init += 26
	#compteur_init += compteur_old if compteur_old < 33 && compteur_init < 28
	#if compteur_init > 13
	#		dif_compteur = compteur_old == 28 ? 15 : (compteur_init > 49 ? 5 : 60 - (compteur_init < compteur_old ? compteur_init : compteur_old))
	#		cpt = (compteur_init > compteur_old ? compteur_init : compteur_old).to_s
	#		0.upto(dif_compteur){ |i|
	#			pdf.text "\n"			
	#		}
	#else
	#	pdf.text "\n\n"
	#end
	
        compteur_init += 26	
	if compteur_init > 50
		compteur_init = 0
	end

	pdf.text "\n\n * prestation exonérée de TVA en vertu de l’article 196 de la directive 2006/112/CE modifiée – article 283-2 du CGI", :size=>10, :style=>:italic unless @facture.devi.tva
	pdf.text "\n\nDate de paiement : #{@facture.cond_reglement == "net dans 30 jours." ? (@facture.created_at + 2592000).strftime('%d/%m/%Y') : @facture.created_at.strftime('%d/%m/%Y')}", :size => 10
	pdf.text "Conditions de paiement : #{@facture.cond_reglement}", :size => 10 
	pdf.text "Taux de pénalités de retard 12%", :size => 10
	pdf.text "Condition d'escompte : sans escomptes", :size => 10
	pdf.text "Siège social : Tharsis software 183-189 avenue de Choisy 75013 Paris\n\n", :size => 10
	pdf.text "\n\n\n"

	if compteur_init > 30
		0.upto((compteur_init - 50)+10){ |i|
			pdf.text "\n"
		}
	end
	pdf.image @pigsfacture, :scale => 0.6, :vposition => :bottom, :position=>:center
#point = [0, pdf.bounds.bottom + 25]
#pdf.repeat :all do
#    pdf.bounding_box point, :width => 535  do
#	pdf.text "Tharsis Software - S.A.R.L. au capital de 10 500€", :align => :center, :size => 8
#	pdf.text "RCS PARIS 493 029 839 - SIRET 493 029 839 00021 - TVA FR64493029839", :align => :center, :size => 8
#    end
#end

pdf.number_pages "<page>/<total>", [pdf.bounds.right, 0]
