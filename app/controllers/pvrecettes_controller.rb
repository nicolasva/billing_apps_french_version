class PvrecettesController < ApplicationController
  respond_to :html, :pdf
  def index
    @pvrecettes = params[:devi_id].nil? ? Pvrecette.where(:created_at=>Time.local(params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")..Time.local((params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i)+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")).all : Pvrecette.where(:created_at=>Time.local(params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")..Time.local((params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i)+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S"), :devi_id=>params[:devi_id]) 
    respond_with @pvrecettes
  end

  # GET /pvrecettes/1
  # GET /pvrecettes/1.xml
  def show
    @totalsumgeneral = 0
    @hash_totalsnumgeneral = Hash.new
    @total_facture_ht = 0
    @total_facture_ttc = 0
    @total_facture_attente_paiement_ht = 0
    @total_facture_attente_paiement_ttc = 0 
    @total_facture_paiement_ht = 0
    @total_facture_paiement_ttc = 0
    @pvrecette = Pvrecette.find(params[:pvrecette_id])
  
    respond_with(@pvrecette)
  end

  def calculpvrecettes	
    @totalsumgeneral = 0
    @hash_totalsnumgeneral = Hash.new
    @total_facture_ht = params[:total_ht].to_i
    @total_facture_ttc = params[:total_ttc].to_i
    @total_facture_attente_paiement_ht = 0
    @total_facture_attente_paiement_ttc = 0 
    @total_facture_paiement_ht = 0
    @total_facture_paiement_ttc = 0
    @facture = Facture.find(params[:facture_id])
  end

  # GET /pvrecettes/new
  # GET /pvrecettes/new.xml
  def new
    #render :text=>params[:devi_id]
    devi = Devi.find(params[:devi_id])
    unless devi.factures.all.empty?
    	@pvrecette = Pvrecette.new(:devi_id=>params[:devi_id].to_i, :numpvrecette=>get_numpvrecette)
    	@pvrecette.save

    	factures = devi.factures
    	@pvrecette.factures.push(factures)

    	redirect_to edit_pvrecette_path(@pvrecette)
    else
	    flash[:notice] = "Vous devez avoir créer des factures afin de pouvoir poursuivre la création de ce PV de recette"
	    redirect_to(:controller=>"devis", :action=>"index", :client_id=>devi.client_id)
    end

    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.xml  { render :xml => @pvrecette }
    #end
  end

  # GET /pvrecettes/1/edit
  def edit
    @hash_totalsnumgeneral = Hash.new
    @total_facture_ht = 0
    @total_facture_ttc = 0
    @total_facture_attente_paiement_ht = 0
    @total_facture_attente_paiement_ttc = 0 
    @total_facture_paiement_ht = 0
    @total_facture_paiement_ttc = 0
    @pvrecette = Pvrecette.find(params[:id])
  end

  # POST /pvrecettes
  # POST /pvrecettes.xml
  def create
    params[:pvrecette][:numpvrecette] = get_numpvrecette
    @pvrecette = Pvrecette.new(params[:pvrecette])

      if @pvrecette.save
		flash[:notice] = "L'enregistrement de ce nouveau procès verbal s'est bien déroulé, il est désormais disponible"
      	        redirect_to :controller=>"pvrecettes", :action=>"index", :id=>@pvrecette.facture.devi.id
      else
	        flash[:notice] = "L'enregistrement de ce nouveau procès verbal ne s'est pas déroulé correctement, il n'est pas disponible"
      		redirect_to(:back)
      end
  end

  # PUT /pvrecettes/1
  # PUT /pvrecettes/1.xml
  def update
    params[:pvrecette][:facture_ids] ||= []
    @pvrecette = Pvrecette.find(params[:id])

      if @pvrecette.update_attributes(params[:pvrecette])
        #format.html { redirect_to(@pvrecette, :notice => 'Pvrecette was successfully updated.') }
        #format.xml  { head :ok }
        flash[:notice] = "L'enregistrement des informations concernant ce pv de recette s'est bien déroulé"
	redirect_to(:controller=>"pvrecettes", :action=>"index", :devi_id=>@pvrecette.devi_id)
      else
        #format.html { render :action => "edit" }
        #format.xml  { render :xml => @pvrecette.errors, :status => :unprocessable_entity }
        flash[:notice] = "L'enregistrement des information concernant ce pv de recette ne s'est pas déroulé correctement il n'est pas disponible"
        respond_with(@pvrecette)
      end
  end

  # DELETE /pvrecettes/1
  # DELETE /pvrecettes/1.xml
  def destroy
    @pvrecette = Pvrecette.find(params[:id])
    flash[:notice] = @pvrecette.destroy ? "La supression de ce pv de recettes s'est bien déroulé il n'est plus disponible" : "La supression de ce pv de recettes ne s'est pas déroulé correctement il est encore disponible"

    respond_with(@pvrecette)
  end

  private
  def get_numpvrecette
  	nombrepvrecette = 1
	numpvrecette = "PV00#{nombrepvrecette}-#{Time.now.strftime("%Y")}"

	pvrecettes = Pvrecette.where("created_at >= :created_at", {:created_at => Time.local(Time.now.strftime("%Y"),1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")}).all
	unless pvrecettes.empty?
		pvrecettes.each{ |pvrecette|
			if pvrecette.numpvrecette.split("-")[0].scan(/^PV(.{1,})$/)[0][0].to_i > nombrepvrecette
				nombrepvrecette = pvrecette.numpvrecette.split("-")[0].scan(/^PV(.{1,})$/)[0][0].to_i
			end
		}
		numpvrecette = (nombrepvrecette.to_i + 1).to_s.rjust(4,"0")
		numpvrecette = "PV#{numpvrecette}-#{Time.now.strftime("%Y")}"
	end

	numpvrecette
  end
end
