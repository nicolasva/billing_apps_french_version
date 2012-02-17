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

pdf.bounding_box [200,510], :width => 400  do
	pdf.text "Procès verbal de Recette", :style => :bold, :size=>20
end

header = [Prawn::Table::Cell.new(:position => [0,0],
:width => 0,
:text => "Adresse",
:font_size => 10)]

items = [[Prawn::Table::Cell.new(:position => [0,0],
:width => 0,
:text => "Adresse",
:font_size => 10)]]

items += [[Prawn::Table::Cell.new(:text=>"#{@pvrecette.devi.client.nameentreprise}\n#{@pvrecette.devi.client.adresse}")]]

pdf.bounding_box [350,450], :width => 200  do
    pdf.table(items, :border_style => :grid,
	      :header => header,
              :width => 200) 
end


header = [Prawn::Table::Cell.new(:position => [0,0],
:width => 0,
:text => "Date",
:font_size => 10),Prawn::Table::Cell.new(:position => [0,0],
:width => 0,
:text=>"N° du client",
:font_size => 10)]

items = [[Prawn::Table::Cell.new(:text => @pvrecette.created_at.strftime('%d/%m/%Y'), :document => self, :font_size=>10),
	  Prawn::Table::Cell.new(:text => @pvrecette.devi.client_id, :document => self, :font_size=>10)]] 

pdf.bounding_box [0, 365], :width => 200 do
    	pdf.table(items, :border_style => :grid,
		:headers => header,
		:column_widths => {0 => 100, 1 => 100},
		:align => {0 => :left, 1 => :left},
		:width => 200)
end


line_factures = ""
@pvrecette.factures.each{ |facture|
	line_factures += "#{facture.numfacture}\n"
}

header = [Prawn::Table::Cell.new(:position => [0,0],
          :width => 0,
          :text =>"N° de facture",
          :font_size => 10),Prawn::Table::Cell.new(:position => [0,0], :width => 0, :text => "N° de PV de recette", :font_size => 10)]

items = [[Prawn::Table::Cell.new(:text => line_factures, :document => self, :font_size=>10, :font_style => :bold),Prawn::Table::Cell.new(:text => @pvrecette.numpvrecette, :document => self, :font_size=>10)]]

pdf.text "\n"
	pdf.table(items, :border_style => :grid,
        	:headers => header,
         	:column_widths => {0 => 100, 1 => 100},
         	:align => {0 => :left, 1 => :left},
         	:width => 200)
pdf.text "\n"

header = [Prawn::Table::Cell.new(:position => [0,0],
          :width => 0,
          :text => "Désignation",
          :font_size => 10),Prawn::Table::Cell.new(:position => [0,0], :width => 0, :text => "")]

items = [[Prawn::Table::Cell.new(:text=>@pvrecette.devi.description, :document => self, :font_size=>10),Prawn::Table::Cell.new(:text=>"", :document => self)],[Prawn::Table::Cell.new(:text=>"TOTAL HT", :document => self, :font_size=>10),Prawn::Table::Cell.new(:text=>get_pvrecette_ttc(@pvrecette.factures)[1], :document => self, :font_size=>10)],[Prawn::Table::Cell.new(:text=>"TOTAL TTC (en euros)", :document => self, :font_size=>10),Prawn::Table::Cell.new(:text=>@total_facture_ttc, :document => self, :font_size=>10)]]

	pdf.table(items, :border_style => :grid,
        	:headers => header,
         	:column_widths => {0 => 440, 1 => 74},
         	:align => {0 => :left, 1 => :left},
         	:width => 535)

items = [[Prawn::Table::Cell.new(:text => "La recette est déclarée prononcée\n Procés verbal établi le : ", :document => self, :font_size=>10, :height => 90),
	  Prawn::Table::Cell.new(:text => "", :document => self)]] 

pdf.text "\n\n"
    	pdf.table(items, :border_style => :grid,
		:column_widths => {0 => 440, 1 => 74},
		:align => {0 => :left, 1 => :left},
		:width => 535)

pdf.number_pages "<page>/<total>", [pdf.bounds.right, 0]
