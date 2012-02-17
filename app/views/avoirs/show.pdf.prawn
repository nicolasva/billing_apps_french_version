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

pdf.bounding_box [320, 620], :width => 200 do
	pdf.text @avoir.facture.devi.client.namerefcontact, :size => 10
	pdf.text @avoir.facture.devi.client.nameentreprise, :style => :bold, :size => 10
	@avoir.facture.devi.client.adresse.each_line{ |line|
		pdf.text line, :size => 10
	}
end

pdf.bounding_box [190, 500], :width => 200 do 
	pdf.text "Facture d'avoir #{@avoir.numavoir}", :style => :bold, :size => 15
end

pdf.bounding_box [0, 400], :width => 280 do
	pdf.text "Numéro de facture correspondante : #{@avoir.facture.numfacture}", :style => :bold
end

header = [Prawn::Table::Cell.new(:position => [0,0],
:width => 0,
:text => "Désignation",
:font_size => 10),Prawn::Table::Cell.new(:position => [0,0], :width=>0, :text=>"en Euros", :font_size => 10)]

items = [[Prawn::Table::Cell.new(:text => @avoir.designation, :document => self, :font_size=>10),
	Prawn::Table::Cell.new(:text => @avoir.price, :document => self, :font_size=>10)],[Prawn::Table::Cell.new(:text=>"TOTAL TVA (19.6%)", :document => self, :font_size=>10),Prawn::Table::Cell.new(:text=>"#{format("%.2f",@avoir.price*19.6/100)}", :document => self, :font_size=>10)],[Prawn::Table::Cell.new(:text=>"TOTAL TTC", :document => self, :font_size=>10),Prawn::Table::Cell.new(:text=>"#{format("%.2f", (@avoir.price*19.6/100)+@avoir.price)}", :document => self, :font_size=>10)]]

pdf.bounding_box [0, 350], :width => 530 do
	pdf.table(items, :border_style => :grid,
		  :headers => header,
                  :column_widths => {0 => 265, 1 => 265},
		  :align => {0 => :left, 1 =>:right},
		  :width => 530)
end

items = [[Prawn::Table::Cell.new(:text => "TOTAL à retirer TTC (TVA 19.6%)"),Prawn::Table::Cell.new(:text=>"#{format("%.2f", (@avoir.price*19.6/100)+@avoir.price)}", :document => self, :font_size=>10)]]
pdf.bounding_box [0, 230], :width => 530 do
	pdf.table(items, :border_style => :grid,
		  :column_widths => {0 => 265, 1 => 265},
                  :align => {0 => :left, 1 => :right},
                  :width => 530)
end

pdf.bounding_box [0, 150], :width => 500 do 
	pdf.text "Siege social : Tharsis software 183-189 avenue de Choisy 75013 Paris", :style=>:italic
end

pdf.number_pages "<page>/<total>", [pdf.bounds.right, 0]
