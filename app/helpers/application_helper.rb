module ApplicationHelper
	def get_url_back(request_referrer)
		link_to(image_tag("img_general/fleche.png", :size=>"68x68"), request_referrer, :title=>"Retour à la page précèdente") unless request_referrer.to_s == "/"  
	end

	def get_controller_name_link_menu(controllername,actionname)
		case controllername
			when "factures"
				result = true
				case actionname
					when "index"
						if params[:client_id].nil? && !params[:devi_id].nil?
							client_id = Devi.find(params[:devi_id]).client_id
						else
						       unless params[:client_id].nil?
								client_id = params[:client_id]
							else
								result = false
						        end
						end
					when "edit"
						facture = Facture.find(params[:id])
						client_id = facture.devi.client_id
				else
			  	result = false
				end
			       if result
				link_to image_tag("img_general/devis.png"), {:controller=>"devis", :action=>"index", :client_id=>client_id}, :title=>"Accéder à la page des devis de ce client"
			       else
				link_to(image_tag("img_general/devis.png"), {:controller=>"/devis", :action=>"index"}, :title=>"Accéder à la page des devis")
			       end	
			 else
			link_to image_tag("img_general/devis.png"), {:controller=>"devis", :action=>"index"}, :title=>"Accéder à la page des devis de ce client"
		end
	end
end
