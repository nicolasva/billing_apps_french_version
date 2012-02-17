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

pdf.bounding_box [200, 510], :width => 400 do
	pdf.text "Bon de livraison", :style => :bold, :size => 20
end

header = [Prawn::Table::Cell.new(:position => [0,0],
:width => 0,
:text => "Adresse de livraison",
:font_size => 10)]

items = [[Prawn::Table::Cell.new(:text=>"#{@bonlivraison.devi.client.nameentreprise}\n#{@bonlivraison.adresselivraison}", :document => self, :font_size=>10)]]

	headers_livraisons = [Prawn::Table::Cell.new(:position => [0,0],
	:width => 0,
	:text => "Adresse de facturation",
	:font_size => 10)]

	items_livraisons = [[Prawn::Table::Cell.new(:text=>"#{@bonlivraison.devi.client.namerefcontact}\n#{@bonlivraison.devi.client.nameentreprise}\n#{@bonlivraison.devi.client.adresse}", :document => self, :font_size=>10)]]
pdf.bounding_box [320, 460], :width => 200 do
	pdf.table(items, :border_style => :grid,
		 :headers => header,
                 :column_widths => {0 => 200},
		 :align => {0 => :left},
		 :width => 200)

	pdf.text "\n"
	pdf.table(items_livraisons, :border_style => :grid,
        	:headers => headers_livraisons,
         	:column_widths => {0 => 200},
         	:align => {0 => :left},
         	:width => 200)
end

header = [Prawn::Table::Cell.new(:position => [0,0],
          :width => 0,
          :text => "Date",
          :font_size => 10),Prawn::Table::Cell.new(:position => [0,0], :width => 0, :text => "N° du client", :font_size => 10)]

items = [[Prawn::Table::Cell.new(:text=>"#{@bonlivraison.created_at.strftime("%d/%m/%y")}", :document => self, :font_size=>10), Prawn::Table::Cell.new(:text=>"#{@bonlivraison.devi.client.numclient}", :document => self, :font_size=>10)]]


	headers_livraisons = [Prawn::Table::Cell.new(:position => [0,0],
	:width => 0,
	:text => "Adresse de facturation",
	:font_size => 10)]

	items_livraisons = [[Prawn::Table::Cell.new(:text=>"#{@bonlivraison.devi.client.namerefcontact}\n#{@bonlivraison.devi.client.nameentreprise}\n#{@bonlivraison.devi.client.adresse}", :document => self, :font_size=>10)]]
pdf.bounding_box [0, 410], :width => 200 do
	pdf.table(items, :border_style => :grid,
		 :headers => header,
                 :column_widths => {0 => 100, 1 => 100},
		 :align => {0 => :left, 1 => :left},
		 :width => 200)

end
 
header = [Prawn::Table::Cell.new(:position => [0,0],
          :width => 0,
          :text =>"N° de facture",
          :font_size => 10),Prawn::Table::Cell.new(:position => [0,0], :width => 0, :text => "N° de bon de livraison", :font_size => 10)]

line_factures = ""
@bonlivraison.factures.each{ |facture|
	line_factures += "#{facture.numfacture}\n"
}
items = [[Prawn::Table::Cell.new(:text => line_factures, :document => self, :font_size=>10, :font_style => :bold),Prawn::Table::Cell.new(:text => @bonlivraison.numlivraison, :document => self, :font_size=>10)]]

pdf.bounding_box [0, 350], :width => 200 do
	pdf.table(items, :border_style => :grid,
        	:headers => header,
         	:column_widths => {0 => 100, 1 => 100},
         	:align => {0 => :left, 1 => :left},
         	:width => 200)
end

@bonlivraison.devi.client.adresse.each_line{ |line|
	pdf.text "\n"
}

@bonlivraison.adresselivraison.each_line{ |line|
	pdf.text "\n"
}

header = [Prawn::Table::Cell.new(:position => [0,0],
:width => 0,
:text => "Désignation",
:font_size => 10),Prawn::Table::Cell.new(:position => [0,0],
:width => 0,
:text => "",
:font_size => 10)]

items = Array.new
items_contener_general = Array.new
@bonlivraison.factures.each{ |facture|
	items_contener = Array.new
        line_informationligne_name = ""
	facture.devi.informationlignes.each{ |informationligne|	
		line_informationligne_name += "#{informationligne.name}\n"
	}

	items_contener.push(Prawn::Table::Cell.new(:text => line_informationligne_name, :document => self, :font_size => 10),Prawn::Table::Cell.new(:text => "", :document => self, :font_size => 10))
	items.push(items_contener)
}

items.push([Prawn::Table::Cell.new(:text => "Total TTC (en euros)", :document => self, :font_size=>10), Prawn::Table::Cell.new(:text=>format("%.2f", total_ttc_bonlivraison(@bonlivraison.factures)).to_s, :document => self, :font_size=>10)])

#items.push(items_contener)

	pdf.table(items, :border_style => :grid,
        	:headers => header,
         	:column_widths => {0 => 275, 1=>275},
         	:align => {0 => :left, 1 => :left},
         	:width => 550)


pdf.text "\n\n"

items = [[Prawn::Table::Cell.new(:text=>"Mode de réglement", :document => self, :font_size=>10), Prawn::Table::Cell.new(:text=>"Chèque ou virement", :document => self, :font_size=>10),Prawn::Table::Cell.new(:text=>"", :document => self, :font_size=>10)]]
pdf.table(items, :border_style => :grid,
:column_widths => {0 => 183, 1 => 183, 2 => 183},
:align => {0 => :left, 1 => :left, 2 => :left},
:width => 550)

pdf.text "\n\n"

items = [[Prawn::Table::Cell.new(:text=>"Commentaires", :document => self, :height=>100, :font_size=>10), Prawn::Table::Cell.new(:text=>"", :document => self, :font_size=>10)]]
pdf.table(items, :border_style => :grid,
:column_widths => {0 => 275, 1 => 275},
:align => {0 => :left, 1 => :left},
:width => 550)

pdf.number_pages "<page>/<total>", [pdf.bounds.right, 0]
