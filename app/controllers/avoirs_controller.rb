class AvoirsController < ApplicationController
  # GET /avoirs
  # GET /avoirs.xml
  respond_to :html, :pdf
  def index
    if params[:facture_id].nil?
    	@avoirs = Avoir.where(:created_at=>Time.local(params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")..Time.local((params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i)+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")).all
    else
    	@avoirs = Avoir.where(:created_at=>Time.local(params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")..Time.local((params[:year].nil? ? Time.now.strftime("%Y").to_i : params[:year].to_i)+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S"), :facture_id=>params[:facture_id])
    end
    respond_with @avoirs
  end

  # GET /avoirs/1
  # GET /avoirs/1.xml
  def show
    @avoir = Avoir.find(params[:avoir_id])

    respond_with(@avoir)
    #respond_to do |format|
    #  format.html # show.html.erb
    #  format.xml  { render :xml => @avoir }
    #end
  end

  # GET /avoirs/new
  # GET /avoirs/new.xml
  def new
    @avoir = Avoir.new(:facture_id=>params[:facture_id].to_i, :numavoir=>get_numavoir)
    @avoir.save

    redirect_to edit_avoir_path(@avoir)
  end

  # GET /avoirs/1/edit
  def edit
    @avoir = Avoir.find(params[:id])
  end

  # POST /avoirs
  # POST /avoirs.xml
  def create
    @avoir = Avoir.new(params[:avoir])
  end

  # PUT /avoirs/1
  # PUT /avoirs/1.xml
  def update
    @avoir = Avoir.find(params[:id])

    #respond_to do |format|
    #  if @avoir.update_attributes(params[:avoir])
     #   format.html { redirect_to(@avoir, :notice => 'Avoir was successfully updated.') }
      #  format.xml  { head :ok }
      #else
       # format.html { render :action => "edit" }
       # format.xml  { render :xml => @avoir.errors, :status => :unprocessable_entity }
      #end
    #end
    
	if @avoir.update_attributes(params[:avoir])	
		flash[:notice] = "La mise à jour concernant les informations de cet avoir s'est déroulé correctement"
		redirect_to :controller=>"avoirs", :action=>"index", :facture_id=>@avoir.facture_id
	else
		flash[:notice] = "La mise à jour concernant les informations de cet avoir ne s'est pas déroulé correctement est n'est donc pas disponible"
		respond_with(@avoir)
	end
  end

  # DELETE /avoirs/1
  # DELETE /avoirs/1.xml
  def destroy
    @avoir = Avoir.find(params[:id])
    flash[:notice] = @avoir.destroy ? "La supression de cette avoir s'est bien déroulé il n'est plus disponible" : "La supression de cette avoir n'est pas déroulé correctement il est encore disponible"
    respond_with(@avoir)

    #respond_to do |format|
    #  format.html { redirect_to(avoirs_url) }
    #  format.xml  { head :ok }
    #end
  end

  private
  def get_numavoir
	time_now = Time.now
 	nombreavoir = 1
        numavoir = "A000#{nombreavoir}-#{Time.now.strftime("%Y")}"

	avoirs = Avoir.where("created_at >= :created_at", {:created_at => Time.local(Time.now.strftime("%Y"),1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")}).all
	unless avoirs.empty?
		avoirs.each{ |avoir|
			if avoir.numavoir.split("-")[0].scan(/^A(.{1,})$/)[0][0].to_i > nombreavoir
				nombreavoir = avoir.numavoir.split("-")[0].scan(/^A(.{1,})$/)[0][0].to_i
			end
		}
		numavoir = (nombreavoir.to_i + 1).to_s.rjust(4,"0")
		numavoir = "A#{numavoir}-#{Time.now.strftime("%Y")}"
	end
        numavoir	
  end
end
