class BonlivraisonsController < ApplicationController
  # GET /bonlivraisons
  # GET /bonlivraisons.xml
  respond_to :html, :pdf
  def index
    @bonlivraisons = params[:devi_id].nil? ? Bonlivraison.where(:created_at=>Time.local(params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")..Time.local((params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i)+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")).all : Bonlivraison.where(:created_at=>Time.local(params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")..Time.local((params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i)+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S"), :devi_id=>params[:devi_id].to_i)
    respond_with(@bonlivraisons)
  end

  # GET /bonlivraisons/1
  # GET /bonlivraisons/1.xml
  def show
    @total_facture_ht = 0
    @total_facture_ttc = 0
    @total_facture_attente_paiement_ht = 0
    @total_facture_attente_paiement_ttc = 0
    @total_facture_paiement_ht = 0
    @total_facture_paiement_ttc = 0
    @bonlivraison = Bonlivraison.find(params[:bonlivraison_id])

    #respond_to do |format|
    #  format.html # show.html.erb
    #  format.xml  { render :xml => @bonlivraison }
    #end
    respond_with(@bonlivraison)
  end

  # GET /bonlivraisons/new
  # GET /bonlivraisons/new.xml
  def new
     devi = Devi.find(params[:devi_id])
     unless devi.factures.all.empty?
    	@bonlivraison = Bonlivraison.new(:devi_id=>params[:devi_id].to_i, :numlivraison=>get_numbonlivraison)
    	@bonlivraison.save
    
        factures = devi.factures
        @bonlivraison.factures.push(factures)

    	redirect_to edit_bonlivraison_path(@bonlivraison)
     else
	    flash[:notice] = "Vous devez avoir créer des factures afin de pouvoir poursuivre la création de ce PV de recette"
     	    redirect_to(:controller=>"devis", :action=>"index", :client_id=>devi.client_id)
     end
  end

  # GET /bonlivraisons/1/edit
  def edit
	@total_facture_ht = 0
	@total_facture_ttc = 0
   	@total_facture_attente_paiement_ht = 0
   	@total_facture_attente_paiement_ttc = 0
	@total_facture_paiement_ht = 0
	@total_facture_paiement_ttc = 0
    	@bonlivraison = Bonlivraison.find(params[:id])
  end

  # POST /bonlivraisons
  # POST /bonlivraisons.xml
  def create
    @bonlivraison = Bonlivraison.new(params[:bonlivraison])

    respond_to do |format|
      if @bonlivraison.save
        format.html { redirect_to(@bonlivraison, :notice => 'Bonlivraison was successfully created.') }
        format.xml  { render :xml => @bonlivraison, :status => :created, :location => @bonlivraison }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bonlivraison.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bonlivraisons/1
  # PUT /bonlivraisons/1.xml
  def update
    params[:bonlivraison][:facture_ids] ||= []
    @bonlivraison = Bonlivraison.find(params[:id])

    #respond_to do |format|
      if @bonlivraison.update_attributes(params[:bonlivraison])
         flash[:notice] = "Les modifications concernant ce bon de livraison s'est bien déroulé elle est désormais disponible"
     #   format.html { redirect_to(@bonlivraison, :notice => 'Bonlivraison was successfully updated.') }
     #   format.xml  { head :ok }
	 redirect_to :controller=>"bonlivraisons", :action=>"index", :devi_id=>@bonlivraison.devi_id
      else
	 flash[:notice] = "Les modifications concernent ce bon de livraison ne s'est pas déroulé correctement et n'est donc pas disponible"
      #  format.html { render :action => "edit" }
      #  format.xml  { render :xml => @bonlivraison.errors, :status => :unprocessable_entity }
      	 respond_with(@bonlivraison)
      end
    #end
  end

  # DELETE /bonlivraisons/1
  # DELETE /bonlivraisons/1.xml
  def destroy
    @bonlivraison = Bonlivraison.find(params[:id])
    flash[:notice] = @bonlivraison.destroy ? "La supression de ce bon de livraison s'est bien déroulé, elle n'est plus disponible" : "La supression de ce bon de livraison ne s'est pas déroulé correctement, il est encore disponible"

    respond_with(@bonlivraison)

    #respond_to do |format|
    #  format.html { redirect_to(bonlivraisons_url) }
    #  format.xml  { head :ok }
    #end
  end

  private
  def get_numbonlivraison
  	nombrebonlivraison = 1
	numbonlivraison = "BL000#{nombrebonlivraison}-#{Time.now.strftime("%Y")}"

	bonlivraisons = Bonlivraison.where("created_at >= :created_at", {:created_at => Time.local(Time.now.strftime("%Y"),1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")}).all
	unless bonlivraisons.empty?
		bonlivraisons.each{ |bonlivraison|
			if bonlivraison.numlivraison.split("-")[0].scan(/^BL(.{1,})$/)[0][0].to_i > nombrebonlivraison
			    nombrebonlivraison = bonlivraison.numlivraison.split("-")[0].scan(/^BL(.{1,})$/)[0][0].to_i
			end
		}
		numbonlivraison = (nombrebonlivraison.to_i + 1).to_s.rjust(4,"0")
		numbonlivraison = "BL#{numbonlivraison}-#{Time.now.strftime("%Y")}"
	end
	numbonlivraison
  end
end
