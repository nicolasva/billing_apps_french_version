class DevisController < ApplicationController
  # GET /devis
  # GET /devis.xml
  respond_to :html, :pdf
  def index
    @total_get_ht = 0
    @total_devi_attente = 0
    unless params[:client_id].nil?
    	@devis = Devi.where(:created_at=>Time.local(params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")..Time.local((params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i)+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S"), :client_id=>params[:client_id]).order(:numdevis).all
    else
    	@devis = Devi.order(:numdevis).where(:created_at=>Time.local(params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")..Time.local((params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i)+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")).all
    end
    #respond_to do |format|
     # format.html # index.html.erb
      #format.xml  { render :xml => @devis }
    #end
    respond_with(@devis)
  end

  # GET /devis/1
  # GET /devis/1.xml
  def show
    @totalsumgeneral = 0
    @hash_totalsnumgeneral = Hash.new
    #@devi = Devi.find(:first, :conditions=>{:id=>params[:id_devi], :numdevis=>params[:id]})
    @devi = Devi.where(:id => params[:id_devi], :numdevis => params[:id]).first
    respond_with(@devi)
  end

  # GET /devis/new
  # GET /devis/new.xml
  def new
    #@devi = Devi.new
   if params[:devi_id_copy].nil?
	@devi = Devi.new(:client_id=>params[:client_id].to_i, :numdevis=>get_numdevis)
    	@devi.save
    	redirect_to edit_devi_path(@devi)
   else
	@devi_find = Devi.find(params[:devi_id_copy])
	@devi = Devi.new(:client_id=>@devi_find.client_id, :description=>@devi_find.description, :tva=>@devi_find.tva, :cond_payment=>@devi_find.cond_payment, :etat=>@devi_find.etat, :devi_id_copy=>params[:devi_id_copy].to_i)
	respond_with @devi
   end
    #respond_with(@devi)
    #respond_to do |format|
     # format.html # new.html.erb
      #format.xml  { render :xml => @devi }
    #end
  end

  # GET /devis/1/edit
  def edit
    @totalsumgeneral = 0
    @hash_totalsnumgeneral = Hash.new
    @devi = Devi.find(params[:id])
  end

  # POST /devis
  # POST /devis.xml
  def create
    devi_id_copy_get_params = Devi.find(params[:devi][:devi_id_copy])
    params[:devi][:description] = devi_id_copy_get_params.description
    params[:devi][:numdevis] = devi_id_copy_get_params.numdevis
    params[:devi][:tva] = devi_id_copy_get_params.tva
    params[:devi][:cond_payment] = devi_id_copy_get_params.cond_payment
    params[:devi][:etat] = devi_id_copy_get_params.etat
    params[:devi][:numdevis] = get_numdevis 
    @devi = Devi.new(params[:devi])
    #@devi.save
    #respond_to do |format|
      #if @devi.save
       # format.html { redirect_to(@devi, :notice => 'Devi was successfully created.') }
        #format.xml  { render :xml => @devi, :status => :created, :location => @devi }
      #else
       # format.html { render :action => "new" }
        #format.xml  { render :xml => @devi.errors, :status => :unprocessable_entity }
      #end
    #end
   
    if @devi.save
        if @devi.set_copy_contenu_devi 
    		flash[:notice] = "Le devi a bien été copié pour ce client" 
		redirect_to(:controller=>"devis", :action=>"index", :client_id=>@devi.client_id)
	else
		flash[:notice] = "Le devi n'a pas été copié pour ce client"	
    		respond_with(@devi)
	end
    else
	flash[:notice] = "Le devi n'a pas été copié pour ce client"
    	respond_with(@devi)
    end
    #result = ""
    #params.keys.each do |k|
    #	result += "<br>"+k
    #end
    #render :text=>result
  end

  # PUT /devis/1
  # PUT /devis/1.xml
  def update
    @devi = Devi.find(params[:id])
   
    #respond_to do |format|
     # if @devi.update_attributes(params[:devi])
      #  format.html { redirect_to(@devi, :notice => 'Devi was successfully updated.') }
       # format.xml  { head :ok }
      #else
       # format.html { render :action => "edit" }
       # format.xml  { render :xml => @devi.errors, :status => :unprocessable_entity }
      #end
    #end
   if @devi.update_attributes(params[:devi])
	   flash[:notice] = "La mise à jour de ce nouveau devis s'est bien déroulé il est désormais disponible"
    	   flash[:id_devi] = @devi.id
	   params.keys.each do |k|
		set_params(k)
           end

	   unless params[:commit].nil?
	   	redirect_to(:controller=>"devis", :action=>"index", :client_id=>@devi.client_id)
	   else
		redirect_to(:back)
	   end
    else
	    flash[:notice] = "La mise à jour de ce nouveau devis ne s'est pas déroulé correctement est n'est donc pas disponible"
    
   	    redirect_to(:back)
    end
    #respond_with(@devi)
  end

  def sort
	  params[params.keys[2]].each_with_index do |id, index|
	  	Informationligne.update_all(['position=?', index+1], ['id=?', id])	
	  end
	  render :nothing => true
  end

  # DELETE /devis/1
  # DELETE /devis/1.xml
  def destroy
    @devi = Devi.find(params[:id])
    flash[:notice] = @devi.destroy ? "La supression de ce devi s'est bien déroulé, il n'est plus disponible" : "La supression de ce devi ne s'est pas déroulé correctement, il est encore disponible"

    respond_with(@devi)
  end

  private
  def set_params(params)
	if params.split("_").length-1 == 5
	   case params.split("_")[0]
	      when "add"
		information_id = params.split("_")[3]
		devi_id = params.split("_")[5]
		unite = information_id.to_i == 1 || information_id.to_i == 4 ? "pce" : "j" 
		informationligne = Informationligne.new(:devi_id=>devi_id, :information_id=>information_id, :unite=>unite)
		informationligne.save
	      when "sup"
		informationligne_id = params.split("_")[5]
		informationligne = Informationligne.find(informationligne_id)
 		informationligne.destroy
	      when "addlignetotal"
		devi_id = params.split("_")[5]
		lignedevi = Lignedevi.new(:name=>"", :prix=>0, :devi_id=>devi_id)
		lignedevi.save
	      when "suplignedevi"
		lignedevi_id = params.split("_")[5]
		lignedevi = Lignedevi.find(lignedevi_id)
		lignedevi.destroy
	      when "addtitre"
	      	information_id = params.split("_")[3].to_i
		devi_id = params.split("_")[5].to_i
		titleinformationligne = Titleinformationligne.new(:title=>"title by default", :information_id=>information_id, :devi_id=>devi_id)
		titleinformationligne.save
	      when "suptitre"
		titleinformationligne_id = params.split("_")[3]
		titleinformationligne = Titleinformationligne.find(titleinformationligne_id)
		titleinformationligne.delete
	   end
       end
	#end
	 #redirect_to(params.split("_").length-1 == 5 ? :back : :controller=>"clients", :action=>"index")
  end

  def get_numdevis
  	#max_devi_id = Devi.maximum('id') 
	nombredevis = 1
	numdevis = "D000#{nombredevis}-#{Time.now.strftime("%Y")}"
     #unless max_devi_id.nil?
#	devi = Devi.find(max_devi_id)
#	unless devi.nil? || devi.numdevis.nil?
#		numdevis = (devi.numdevis.split("-")[0].scan(/^D(.{1,})$/)[0][0].to_i + 1).to_s.rjust(4,"0")
#		numdevis = "D#{numdevis}-#{Time.now.strftime("%Y")}"
#	end
 #     end
      devis = Devi.where("created_at >= :created_at", {:created_at => Time.local(Time.now.strftime("%Y"),1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")}).all
      unless devis.empty?
      		devis.each{ |devi|
			if devi.numdevis.split("-")[0].scan(/^D(.{1,})$/)[0][0].to_i > nombredevis
				nombredevis = devi.numdevis.split("-")[0].scan(/^D(.{1,})$/)[0][0].to_i
			end
			numdevis = (nombredevis.to_i + 1).to_s.rjust(4,"0")
			numdevis = "D#{numdevis}-#{Time.now.strftime("%Y")}"
		}
      end
	numdevis
  end
end
