class FacturesController < ApplicationController
  # GET /factures
  # GET /factures.xml
  respond_to :html, :pdf
  def index
   @total_facture_ht = 0
   @total_facture_ttc = 0
   @total_facture_attente_paiement_ht = 0
   @total_facture_attente_paiement_ttc = 0
   @total_facture_paiement_ht = 0
   @total_facture_paiement_ttc = 0
   @total_facture_paye = 0
   unless params[:client_id].nil?
    #@factures = Facture.joins(:devi).where(:devis => {:client_id=>params[:client_id]}).order(:numfacture)
    @factures = Facture.joins(:devi).where(:created_at=>Time.local(params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")..Time.local((params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i)+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S"), :devis => {:client_id=>params[:client_id]}).order(:numfacture) 
    #@factures = Facture.where("created_at between :last_year and :first_year and proforma='f' and annulation='f'",{:first_year=>Time.local(@year_params+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S"), :last_year=>Time.local(@year_params,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")}).all
   else
 	unless params[:devi_id].nil?
		@factures = Facture.where(:created_at=>Time.local(params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")..Time.local((params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i)+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S"), :devi_id => params[:devi_id]).order(:numfacture)
	else
		@factures = Facture.where(:created_at=>Time.local(params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")..Time.local((params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i)+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")).order(:numfacture)
	end
   end
    #respond_to do |format|
     # format.html # index.html.erb
      #format.xml  { render :xml => @factures }
    #end
    respond_with(@factures)
  end

  # GET /factures/1
  # GET /factures/1.xml
  def show
   if request.request_uri != "/allfactures" && (request.request_uri == "/rapports" || request.request_uri == "/downloadrapports" || request.request_uri.scan(/^(.{1,})?\?.{1,}?$/)[0][0] == "/rapports" || request.request_uri.scan(/^(.{1,})?\?.{1,}?$/)[0][0] == "/downloadrapports")
   	#Time.local(2011,1,1,0,0,0)
	@hash_name_client = Hash.new
	@hash_name_client_facture_encaisse = Hash.new
	@tab_result_facture_ttc_ht_by_month = Array.new
	@tab_result_facture_encaisse_ttc_ht_by_month = Array.new
	@tab_result_facture_ttc_ht = Array.new
	@tab_result_facture_encaisse_ttc_ht = Array.new
	@tab_facture_name_client = Array.new
	@total_facture_ht = 0
	@total_facture_ttc = 0
   	@total_facture_attente_paiement_ht = 0
   	@total_facture_attente_paiement_ttc = 0
	@total_facture_paiement_ht = 0
	@total_facture_paiement_ttc = 0
	@time_now = Time.now
	@year_params = (params[:year].nil? ? @time_now.strftime("%Y").to_i : params[:year].to_i)
	@factures = Facture.where("created_at between :last_year and :first_year and proforma='f' and annulation='f'",{:first_year=>Time.local(@year_params+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S"), :last_year=>Time.local(@year_params,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")}).all
  	@factures_encaisses = Facture.where("datepaiement between :last_year and :first_year and created_at <= :time_now and proforma='f' and annulation='f' and datepaiementcheck='t'",{:first_year=>Time.local(@year_params+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S"), :last_year=>Time.local(@year_params,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S"),:time_now=>@time_now.strftime("%Y-%m-%d %H:%M:%S")}) 
   else
      unless request.request_uri == "/allfactures"
    	@totalsumgeneral = 0
    	@hash_totalsnumgeneral = Hash.new
    	@facture = Facture.where(:numfacture=>params[:id], :id=>params[:facture_id]).first
        	if @facture.choixrib == "rib"	
			@pigsfacture = "#{RAILS_ROOT}/public/images/img_logo_tharsis/rib/tharsis.png"
		else
			@pigsfacture = "#{RAILS_ROOT}/public/images/img_logo_tharsis/factobail/facto.png"
		end
      else
      	@time_now = Time.now
	@time_min = @time_now - (86400 * 31)
		
      end
   end	
	 #render :text=>request.request_uri
	if !request.request_uri == "/downloadrapports" || (request.request_uri.scan(/^(.{1,})?\?.{1,}?$/)[0].nil? || !request.request_uri.scan(/^(.{1,})?\?.{1,}?$/)[0][0] == "/downloadrapports")
		respond_with(@facture) 
	end
  end

  def redirection_download_excel
  	redirect_to "/rapport_excel/rapport_excel.xls"
  end

  # GET /factures/new
  # GET /factures/new.xml
  def new
    devi = Devi.find(params[:devi_id].to_i)
    @facture = Facture.new(:devi_id=>params[:devi_id], :numfacture=>get_numfacture, :choixrib=>(devi.client.affacturage ? "factobail" : "rib"))
    @facture.save

    redirect_to edit_facture_path(@facture)
    #respond_with(@facture)
    #respond_to do |format|
     # format.html # new.html.erb
      #format.xml  { render :xml => @facture }
    #end
  end

  # GET /factures/1/edit
  def edit
    @facture = Facture.find(params[:id])
  end

  # POST /factures
  # POST /factures.xml
  def create
   unless request.request_uri == "/generateallfactures"
    	params[:facture][:numfacture] = get_numfacture 
    	@facture = Facture.new(params[:facture])
    	#respond_to do |format|
     		# if @facture.save
      			#  format.html { redirect_to(@facture, :notice => 'Facture was successfully created.') }
       			# format.xml  { render :xml => @facture, :status => :created, :location => @facture }
      		#else
       			# format.html { render :action => "new" }
        		#format.xml  { render :xml => @facture.errors, :status => :unprocessable_entity }
      		#end
    	#end
    
    	#respond_with(@facture)
    	if @facture.save
	    	flash[:notice] = "L'enregistrement de cette nouvelle facture s'est bien déroulé, elle est désormais disponible"
    	    	redirect_to :controller=>"factures", :action=>"index", :id=>@facture.devi_id
    	else
	    	flash[:notice] = "L'enregistrement de cette nouvelle facture ne s'est pas déroulé correctement, elle n'est pas disponible"
	    	redirect_to(:back)
    	end
   else
	time_now = Time.now
        dir_factures_public = "/factures/facture_du_#{time_now.strftime("%Y_%m_%d_%H_%M_%S")}"	
	dir_factures_date = "#{RAILS_ROOT}/public#{dir_factures_public}"
	datepaiement_on = Time.local(params["factures"]["datepaiement_on(1i)"].to_i,params["factures"]["datepaiement_on(2i)"].to_i,params["factures"]["datepaiement_on(3i)"].to_i)
	datepaiement_at = Time.local(params["factures"]["datepaiement_at(1i)"].to_i,params["factures"]["datepaiement_at(2i)"].to_i,params["factures"]["datepaiement_at(3i)"].to_i)
      if datepaiement_on <= datepaiement_at 
	Dir::mkdir(dir_factures_date)
	require "prawn"
	require 'prawn/layout'
	require 'prawn/core'

	pigs = "#{RAILS_ROOT}/public/images/img_logo_tharsis/logotharsis.jpg"
	@factures = Facture.where(:created_at=>datepaiement_on..datepaiement_at)

	@factures.each{ |facture|
		to_pdf(facture,pigs,dir_factures_date)
	}

  	zip_compression("#{dir_factures_date}.zip",dir_factures_date)

  	redirect_to "#{dir_factures_public}.zip"
      else
	      flash[:notice] = "Veuillez choisir une date de départ plus petite que la date de fin"
	      redirect_to(:back)
      end
    	#sFichier_zip = "#{RAILS_ROOT}/public/zip/#{self.id.to_s}/#{self.file_file_name}"
	#sDossier_save = "#{RAILS_ROOT}/public#{self.file.url.scan(/^(.{1,}).zip?.{1,}$/).to_s}"
   end
  end

  # PUT /factures/1
  # PUT /factures/1.xml
  def update
    @facture = Facture.find(params[:id])

    #respond_to do |format|
     # if @facture.update_attributes(params[:facture])
      #  format.html { redirect_to(@facture, :notice => 'Facture was successfully updated.') }
       # format.xml  { head :ok }
      #else
       # format.html { render :action => "edit" }
       # format.xml  { render :xml => @facture.errors, :status => :unprocessable_entity }
      #end
    #end
    	#params[:facture][:datepaiement] = Time.now - @facture.created_at unless params[:facture][:datepaiementcheck] 
    if @facture.update_attributes(params[:facture])
    	flash[:notice] = "Les modifications de cette facture s'est bien déroulé elle est désormais disponible"
    	flash[:id_facture] = @facture.id
	redirect_to :controller=>"factures", :action=>"index", :devi_id=>@facture.devi_id
    else
	flash[:notice] = "Les modifiction de cette facture ne s'est pas déroulé correctement elle n'est pas disponible"
	redirect_to(:back)
    end
  end

  # DELETE /factures/1
  # DELETE /factures/1.xml
  def destroy
    @facture = Facture.find(params[:id])
    	if @facture.destroy
		@facture.pvrecettes.destroy_all
		flash[:notice] = "La supression de cette facture s'est bien déroulé, elle n'est plus disponible" 
	else
		flash[:notice] = "La supression de cette facture ne s'est pas déroulé correctement, elle est encore disponible" 
	end
    #respond_to do |format|
    #  format.html { redirect_to(factures_url) }
    #  format.xml  { head :ok }
    #end
    respond_with(@facture)
  end

  private
  def get_numfacture
	nombrefacture = 1
	numfacture = "F000#{nombrefacture}-#{Time.now.strftime("%Y")}"
 #     unless  max_facture_id.nil?
#	facture = Facture.find(max_facture_id)
#	unless facture.nil? || facture.numfacture.nil?
#		numfacture = (facture.numfacture.split("-")[0].scan(/^F(.{1,})$/)[0][0].to_i + 1).to_s.rjust(4,"0")
#		numfacture = "F#{numfacture}-#{Time.now.strftime("%Y")}"
#	end
      #end
      factures = Facture.where("created_at >= :created_at", {:created_at => Time.local(Time.now.strftime("%Y"),1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")}).all
      unless factures.empty?
      	    factures.each{ |facture|
	    	if facture.numfacture.split("-")[0].scan(/^F(.{1,})$/)[0][0].to_i > nombrefacture
			nombrefacture = facture.numfacture.split("-")[0].scan(/^F(.{1,})$/)[0][0].to_i 
		end
	    }
	    numfacture = (nombrefacture.to_i + 1).to_s.rjust(4,"0")
	    numfacture = "F#{numfacture}-#{Time.now.strftime("%Y")}"
      end
      numfacture
  end


  def zip_compression(sFichier_zip,sDossier_save)		
    	#sFichier_zip = "#{RAILS_ROOT}/public/zip/#{self.id.to_s}/#{self.file_file_name}"
	#sDossier_save = "#{RAILS_ROOT}/public#{self.file.url.scan(/^(.{1,}).zip?.{1,}$/).to_s}"

	require "rubygems"
    	require 'zip/zip'
	require 'pathname'
    	require 'zip/zipfilesystem'
	require 'find'
	Zip::ZipFile.open(sFichier_zip, Zip::ZipFile::CREATE){ |zipfile|
		Find.find(sDossier_save){ |sRes_find|
			sDossier_base = sRes_find[ sDossier_save.length, sRes_find.length ]
			 	if( sDossier_base != "" )
					if(FileTest.directory?(sRes_find))
						zipfile.dir.mkdir(sDossier_base)
					else
						zipfile.file.open(sDossier_base, 'w'){ |f|
						   f.write( File.open(sRes_find, 'rb').read)
						}
					end
				end
		}
			zipfile.close
	}
	system("chmod -R 777 #{sFichier_zip}")
  end

  def to_pdf(facture,pigs,dir_factures_date) 
		totalsumgeneral = 0
		hash_totalsnumgeneral = Hash.new
		Prawn::Document.generate("#{dir_factures_date}/facture_#{facture.numfacture}.pdf") do
			image pigs, :scale => 0.2
		
			
			bounding_box [0,670], :width => 200  do
				text "Tharsis Software", :size => 13, :style => :bold
				text "15 rue Jean-Baptiste Berlier", :size => 10
				text "75013 Paris", :size => 10
				text "01 55 43 79 10", :size=> 10
				text "billing@tharsis-software.com", :size => 10
				text "\n"
        			text "S.A.R.L. au capital de 10500€", :size => 10
				text "RCS Paris 493 029 839", :size => 10
				text "Siret 493 029 839 00021", :size => 10
				text "TVA FR64493029839", :size => 10	
			end


			#compteur_old = 28 
			compteur_init = 28

			bounding_box [320, 620], :width => 200 do 
			
				text facture.devi.client.namerefcontact, :size => 10
				text facture.devi.client.nameentreprise, :style => :bold, :size => 10
				facture.devi.client.adresse.each_line{ |line|
					compteur_init += 1 
					text line, :size => 10
				}
				text facture.devi.client.tva_intra, :size => 10 unless facture.devi.client.tva_intra.empty? && facture.devi.client.tva_intra.nil? 
			end

			if compteur_init > 50
				compteur_init = 0
			end

			bounding_box [0,500], :width => 200 do 
				
				text "FACTURE #{facture.proforma ? "PRO FORMA" : ""}", :style => :bold, :size => 10
				text "Numéro : #{facture.numfacture}", :size => 10
				text "Date : #{facture.created_at.strftime('%d/%m/%Y')}", :size => 10
        			text "Devis : #{facture.devi.numdevis}", :size => 10
				text "Numéro client : #{facture.devi.client.numclient}", :size => 10
        			#pdf.text("Commande : #{@facture.numcommande}", :size => 10) unless @facture.numcommande.nil? || @facture.numcommande.empty?
				unless facture.numcommande.nil? || facture.numcommande.empty?
					facture.numcommande.each_line{ |line|
						compteur_init += 1
						text line, :size => 10
					}	
				end
			end

			if compteur_init > 50
				compteur_init = 0
			end

			text "\n\n"

			text "Description", :style => :bold, :size => 10
			unless facture.devi.description.nil?
				facture.devi.description.each_line{ |line|
					compteur_init += 1
					text line, :size => 10
				}
			end

			Information.all.each{ |information|
				compteur_init += 1
				unless facture.devi.informationlignes.find(:first, :conditions=>{:information_id=>information.id}).nil?
					items = Array.new
					items_temp = Array.new
					unless information.name.nil?
						information.name.each_line{ |line|
							compteur_init += 1
						}
					end

					facture.devi.informationlignes.find(:all, :conditions=>{:information_id=>information.id}, :order => "position").each{ |informationligne|
						informationligne.number.nil? && informationligne.price.nil? ? "" : totalsumgeneral += informationligne.number * informationligne.price
					        items_temp.push((information.name.nil? ? "" : Prawn::Table::Cell.new(:width=>0, :text=>informationligne.name, :font_size=>10)), Prawn::Table::Cell.new(:text=>informationligne.number, :font_size=>10, :width=>0), Prawn::Table::Cell.new(:text=>informationligne.unite, :font_size=>10, :width=>0), Prawn::Table::Cell.new(:text=>format("%.2f",informationligne.price).to_s, :font_size=>10, :width=>0), (informationligne.number.nil? && informationligne.price.nil? ? "" : Prawn::Table::Cell.new(:text=>(format("%.2f", informationligne.number * informationligne.price)).to_s, :width=>0, :font_size=>10)))	
						items.push(items_temp)
						items_temp = Array.new
						compteur_init += 1
					}

					text "\n\n"

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

					hash_totalsnumgeneral[information.name] = totalsumgeneral

					phrase_somme = Prawn::Table::Cell.new(:text => "Somme #{information.name}", :document => self, :font_style => :bold, :font_size => 10)
					totalsumgeneraltable = Prawn::Table::Cell.new(:text => format("%.2f", totalsumgeneral).to_s, :document => self, :font_style => :bold, :font_size=>10)
					items.push([phrase_somme, "", "", "", totalsumgeneral])
					text information.name, :style => :bold
					table items, :border_style => :grid,
						:headers => headers,
						:column_widths => {0 => 270},
						:align => {0 => :left, 1 => :right, 2 => :right, 3 => :right, 4 => :right},
						:width => 535
					end
					totalsumgeneral = 0
			}

			if compteur_init > 50
				compteur_init = 0
			end

			text "Total", :style => :bold, :font_size=>10
			items = Array.new
			items_temp = Array.new
			Information.all.each{ |information|
				unless hash_totalsnumgeneral[information.name].nil?
					items.push(items_temp.push(Prawn::Table::Cell.new(:text=>information.name.nil? ? "" : information.name, :width => 0, :font_size=>10), Prawn::Table::Cell.new(:text=>hash_totalsnumgeneral[information.name], :width => 0, :font_size=>10)))
					totalsumgeneral += hash_totalsnumgeneral[information.name]
				end
				items_temp = Array.new
			}

			total = [[Prawn::Table::Cell.new(:text => "Total #{facture.devi.tva ? "" : "*"}", :document => self, :font_style => (facture.accompte == 100 ? :bold : :normal), :font_size=>10),
				Prawn::Table::Cell.new(:text => format("%.2f", totalsumgeneral).to_s, :document => self, :font_style =>(facture.accompte == 100 ? :bold : :normal), :font_size=>10)]]

			unless facture.devi.lignedevis.empty?
				totallignedevis = Array.new
				facture.devi.lignedevis.each{ |lignedevi|
					totalsumgeneral += lignedevi.prix
					totallignedevis.push([Prawn::Table::Cell.new(:text=>lignedevi.name, :font_style => :normal, :font_size => 10), Prawn::Table::Cell.new(:text=>format("%.2f", lignedevi.prix).to_s, :font_style => :normal, :font_size => 10)])
				}
				totallignedevis.push([Prawn::Table::Cell.new(:text=>"HT", :font_style => facture.accompte == 100 ? :bold : :normal, :font_size => 10),Prawn::Table::Cell.new(:text=>totalsumgeneral.to_s, :font_style => facture.accompte == 100 ? :bold : :normal, :font_size => 10)])	
			end
			
			if facture.accompte == 100
				tva = [[Prawn::Table::Cell.new(
					:text => "TVA 20%", :document => self, :font_style => :bold, :font_size=>10),
					Prawn::Table::Cell.new(
					:text => format("%.2f", totalsumgeneral * 0.2).to_s, :document => self, :font_style => :bold, :font_size=>10)],
					[Prawn::Table::Cell.new(
						:text=> "TTC", :document => self, :font_size=>10, :font_style => :bold), Prawn::Table::Cell.new(:text => format("%.2f", (totalsumgeneral * 0.2) + totalsumgeneral).to_s, :document => self, :font_style => :bold, :font_size=>10)
				]]
			else
				total_accompte = [[Prawn::Table::Cell.new(:text=>"HT (#{facture.accompte}%)", :document => self, :font_style => :bold, :font_size => 10), Prawn::Table::Cell.new(:text=>(format("%.2f", (totalsumgeneral*facture.accompte)/100)).to_s, :document => self, :font_style => :bold, :font_size => 10)]]
			
				tva = [[Prawn::Table::Cell.new(:text=>"TVA 20%", :document => self, :font_style => :bold, :font_size=>10), Prawn::Table::Cell.new(:text=>format("%.2f",(((totalsumgeneral*facture.accompte)/100)*20)/100).to_s, :document => self, :font_style => :bold, :font_size => 10)]]
				
				ttc = [[Prawn::Table::Cell.new(:text=>"TTC", :document => self, :font_style => :bold, :font_size=>10), Prawn::Table::Cell.new(:text=>(format("%.2f", (((totalsumgeneral*facture.accompte)/100)*0.2)+((totalsumgeneral*facture.accompte)/100))).to_s, :document => self, :font_style => :bold, :font_size=>10)]]
				tva += ttc
			end

			items += total
			items += totallignedevis unless facture.accompte == 100 || totallignedevis.nil?
			items += tva if facture.devi.tva?
			header_bis = [Prawn::Table::Cell.new(:position => [0,0],
			:width => 0,
			:text => "Produit",
			:font_style => :bold,
			:font_size => 10), Prawn::Table::Cell.new(:position => [0,0],
			:width => 0,
			:text => "Total net €",
			:font_style => :bold,
			:font_size => 10)]

			table(items, :border_style => :grid,
				  :headers => header_bis,
				  :column_widths => {0 => 430},
				  :align => {0 => :left, 1 => :right},
				  :width => 535)

			compteur_init += 26
			if compteur_init > 50
				compteur_init = 0
			end


			text "\n\n * prestation exonérée de TVA en vertu de l’article 196 de la directive 2006/112/CE modifiée – article 283-2 du CGI", :size=>10, :style=>:italic unless facture.devi.tva
			text "\n\nDate de paiement : #{facture.cond_reglement == "net dans 30 jours." ? (facture.created_at + 2592000).strftime('%d/%m/%Y') : facture.created_at.strftime('%d/%m/%Y')}", :size => 10
			text "Conditions de paiement : #{facture.cond_reglement}", :size => 10 
			text "Taux de pénalités de retard 12%", :size => 10
			text "Condition d'escompte : sans escomptes", :size => 10
			text "Siège social : Tharsis software 183-189 avenue de Choisy 75013 Paris\n\n", :size => 10
			text "\n\n\n"

			if compteur_init > 30
				0.upto((compteur_init - 50)+10){ |i|
					text "\n"
				}
			end

			image (facture.choixrib == "rib" ? "#{RAILS_ROOT}/public/images/img_logo_tharsis/rib/tharsis.png" : "#{RAILS_ROOT}/public/images/img_logo_tharsis/factobail/facto.png"), :scale => 0.6, :vposition => :bottom, :position => :center

			number_pages "<page>/<total>", [bounds.right, 0]
		end
  end
end
