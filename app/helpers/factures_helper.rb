module FacturesHelper
	def get_form_select_accompte
		array_tab_general = Array.new
		array_tab_value = Array.new

		0.upto(10){ |i|
			array_tab_value.push(i*10,i*10)
			array_tab_general.push(array_tab_value)
			array_tab_value = Array.new
		}

		array_tab_general
	end

	def get_facture_ht(facture)
		(get_ht(facture.devi) * facture.accompte) / 100	
	end

	def get_facture_ttc(facture)
	      unless facture.annulation || facture.proforma	
		@total_facture_ht += (get_ht(facture.devi) * facture.accompte) / 100 
		@total_facture_ttc += facture.devi.tva ? ((get_facture_ht(facture) * 0.2) + get_facture_ht(facture)) : get_facture_ht(facture) 
	        unless facture.datepaiementcheck 
			@total_facture_attente_paiement_ht += (get_ht(facture.devi) * facture.accompte) / 100
	      		@total_facture_attente_paiement_ttc += facture.devi.tva ? ((get_facture_ht(facture) * 0.2) + get_facture_ht(facture)) : get_facture_ht(facture)
		end

		if facture.datepaiementcheck
			@total_facture_paiement_ht += (get_ht(facture.devi) * facture.accompte) / 100
			@total_facture_paiement_ttc += facture.devi.tva ? ((get_facture_ht(facture) * 0.2) + get_facture_ht(facture)) : get_facture_ht(facture) 
		end
	      end
		facture.devi.tva ? ((get_facture_ht(facture) * 0.2) + get_facture_ht(facture)) : get_facture_ht(facture)
	end

	def get_total_all_facture_ht_ttc(factures)
		@tab_result_facture_ttc_ht = Array.new	
		get_total_all_facture_ht_ttc_by_month
		get_total_all_facture_by_client_ht_ttc_by_year
		factures.each{ |facture|	
			get_facture_ttc(facture)
		}

		@tab_result_facture_ttc_ht.push(@total_facture_ht,@total_facture_ttc)	
	end

	def get_total_facture_encaisse_ht_ttc(factures_encaisses)	
		get_total_all_facture_encaisse_ht_ttc_by_month
		get_total_all_facture_encaisse_by_client_ht_ttc_by_year
		@tab_result_facture_encaisse_ttc_ht = Array.new
		@total_facture_ht = 0
		@total_facture_ttc = 0
		factures_encaisses.each{ |facture_encaisse|
			#@total_facture_ht += get_facture_ht(facture_encaisse)
			get_facture_ttc(facture_encaisse)
		}

		@tab_result_facture_encaisse_ttc_ht.push(@total_facture_ht,@total_facture_ttc)
	end

	def get_total_all_facture_encaisse_ht_ttc_by_month	
		year_params_last_year = Time.local(@year_params,1,1,0,0,0)
		year_params_first_year = Time.local(@year_params,1,1,0,0,0) + 2678400
		1.upto(@year_params == Time.now.strftime("%Y").to_i ? Time.now.strftime("%m").to_i : 12){ |month|
			@total_facture_ht = 0
			@total_facture_ttc = 0
   			@total_facture_attente_paiement_ht = 0
   			@total_facture_attente_paiement_ttc = 0
   			@total_facture_paiement_ht = 0
   			@total_facture_paiement_ttc = 0

			#factures_encaisses = Facture.where("created_at between :last_year and :first_year and datepaiement <= :time_now and proforma='f' and annulation='f' and datepaiementcheck='t'", {:first_year=>year_params_first_year, :last_year=>year_params_last_year, :time_now=>@time_now}).all
			factures_encaisses = Facture.where("datepaiement between :last_year and :first_year and created_at <= :time_now and proforma='f' and annulation='f' and datepaiementcheck='t'", {:first_year=>year_params_first_year.strftime("%Y-%m-%d %H:%M:%S"), :last_year=>year_params_last_year.strftime("%Y-%m-%d %H:%M:%S"), :time_now=>@time_now.strftime("%Y-%m-%d %H:%M:%S")}).all
			factures_encaisses.each{ |facture_encaisse|	
				get_facture_ttc(facture_encaisse)		
			}
			hash_facture_encaisse_ht_ttc = Hash.new
			hash_facture_encaisse_ht_ttc["total_facture_ht"] = @total_facture_ht
			hash_facture_encaisse_ht_ttc["total_facture_ttc"] = @total_facture_ttc
			@tab_result_facture_encaisse_ttc_ht_by_month.push(hash_facture_encaisse_ht_ttc)	
			year_params_last_year = year_params_first_year
			year_params_first_year = year_params_last_year + 2678400
			
			Rails.logger.info "--=-=-=--=-year_params_first_year.day.to_i-=-=-=-=-#{year_params_first_year.day.to_i}"
			year_params_first_year = Time.local(year_params_first_year.year,year_params_first_year.month,1,0,0,0) if year_params_first_year.day.to_i != 1 
		}
		@tab_result_facture_encaisse_ttc_ht_by_month
	end

	def get_total_all_facture_ht_ttc_by_month
		year_params_last_year = Time.local(@year_params,1,1,0,0,0)
		year_params_first_year = Time.local(@year_params,1,1,0,0,0) + 2592000
		1.upto(@year_params == Time.now.strftime("%Y").to_i ? Time.now.strftime("%m").to_i : 12){ |month|	
			@total_facture_ht = 0
			@total_facture_ttc = 0
   			@total_facture_attente_paiement_ht = 0
   			@total_facture_attente_paiement_ttc = 0
   			@total_facture_paiement_ht = 0
   			@total_facture_paiement_ttc = 0
			factures = Facture.where("created_at between :last_year and :first_year and proforma='f' and annulation='f'", {:first_year=>year_params_first_year.strftime("%Y-%m-%d %H:%M:%S"), :last_year=>year_params_last_year.strftime("%Y-%m-%d %H:%M:%S")}).all
			
			factures.each{ |facture|
				get_facture_ttc(facture)		
			}
			hash_facture_ht_ttc = Hash.new
			hash_facture_ht_ttc["total_facture_ht"] = @total_facture_ht
			hash_facture_ht_ttc["total_facture_ttc"] = @total_facture_ttc
			@tab_result_facture_ttc_ht_by_month.push(hash_facture_ht_ttc)

			year_params_last_year = year_params_first_year
			year_params_first_year = year_params_last_year + 2678400
			year_params_first_year = Time.local(year_params_first_year.year,year_params_first_year.month,1,0,0,0) if year_params_first_year.day.to_i != 1 
		}
		@tab_result_facture_ttc_ht_by_month
	end

	def get_total_all_facture_encaisse_by_client_ht_ttc_by_year
		clients = Client.joins(:devis=>:factures).where(:devis=>{:factures=>{:created_at=>Time.local(@year_params,1,1,0,0,0)..Time.local(@year_params+1,1,1,0,0,0), :proforma=>false, :annulation=>false, :datepaiementcheck=>true, :datepaiement=>Time.local(@year_params,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")..@time_now.strftime("%Y-%m-%d %H:%M:%S")}}).all

		#clients = Client.all
		clients.each{ |client|
			@total_facture_ht = 0
			@total_facture_ttc = 0
			@total_facture_attente_paiement_ht = 0
			@total_facture_attente_paiement_ttc = 0
			@total_facture_paiement_ht = 0
			@total_facture_paiement_ttc = 0

			client.devis.each{ |devi|
				devi.factures.where("datepaiement between :last_year and :first_year and created_at <= :time_now and proforma='f' and annulation='f' and datepaiementcheck='t'", {:first_year=>Time.local(@year_params+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S"), :last_year=>Time.local(@year_params,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S"), :time_now=>@time_now.strftime("%Y-%m-%d %H:%M:%S")}).each{ |facture_encaisse|	
					get_facture_ttc(facture_encaisse)		
				}
			}

			@hash_name_client_facture_encaisse[client.nameentreprise] = {"total_facture_ht"=>@total_facture_ht, "total_facture_ttc"=>@total_facture_ttc}
		}

		order_hash_facture_by_client(@hash_name_client_facture_encaisse)
	end


	def get_total_all_facture_by_client_ht_ttc_by_year
		clients = Client.joins(:devis=>:factures).where(:devis=>{:factures=>{:created_at=>Time.local(@year_params,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")..Time.local(@year_params+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S"), :proforma=>false, :annulation=>false}}).all
		
		clients.each{ |client|
				@total_facture_ht = 0
				@total_facture_ttc = 0
   				@total_facture_attente_paiement_ht = 0
   				@total_facture_attente_paiement_ttc = 0
   				@total_facture_paiement_ht = 0
   				@total_facture_paiement_ttc = 0
			client.devis.each{ |devi|
				devi.factures.where("created_at between :last_year and :first_year and proforma='f' and annulation='f'", {:first_year=>Time.local(@year_params+1,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S"), :last_year=>Time.local(@year_params,1,1,0,0,0).strftime("%Y-%m-%d %H:%M:%S")}).each{ |facture|			
					get_facture_ttc(facture)		
				}
			}
				@hash_name_client[client.nameentreprise] = {"total_facture_ht"=>@total_facture_ht, "total_facture_ttc"=>@total_facture_ttc}
		}

		order_hash_facture_by_client(@hash_name_client)
	end

	def set_rapport_xls
		require "spreadsheet"

		rapports_xls = Spreadsheet::Workbook.new
		worksheet1 = rapports_xls.create_worksheet :name => "CA année #{@year_params}"
		#worksheet1.name = "Chiffre d'affaire HT & TTC sur l'année #{@year_params}"

		worksheet1[0, 1] = "Chiffres d'affaires HT (€)"
		worksheet1[0, 2] = "Chiffres d'affaires TTC (€)"
		
		worksheet1[1,0] = "Total"
	        worksheet1[1,1] = format("%.2f", @tab_result_facture_ttc_ht[0])
		worksheet1[1,2] = format("%.2f", @tab_result_facture_ttc_ht[1])

		worksheet1[3,0] = "Par mois"
			
		compteur_ligne = 4
		0.upto(@tab_result_facture_ttc_ht_by_month.length-1){ |i|
			worksheet1[compteur_ligne, 0] =  month?(i.to_i)
			worksheet1[compteur_ligne, 1] = format("%.2f", @tab_result_facture_ttc_ht_by_month[i]["total_facture_ht"])
			worksheet1[compteur_ligne, 2] = format("%.2f", @tab_result_facture_ttc_ht_by_month[i]["total_facture_ttc"]) 
			compteur_ligne += 1
		}
		compteur_ligne += 1

		worksheet1[compteur_ligne, 0] = "Par Clients"
		compteur_ligne += 1	
		@hash_name_client.each{ |key, value|
			worksheet1[compteur_ligne, 0] = key
			worksheet1[compteur_ligne, 1] = format("%.2f", value["total_facture_ht"])
			worksheet1[compteur_ligne, 2] = format("%.2f", value["total_facture_ttc"])
			compteur_ligne += 1
		}
		worksheet2 = rapports_xls.create_worksheet :name => "CA encaissé sur l'année #{@year_params}"

		#worksheet2[1,0] = 'Japan'
		worksheet2[0, 1] = "Chiffres d'affaires HT (€)"
		worksheet2[0, 2] = "Chiffres d'affaires TTC (€)"

		worksheet2[1,0] = "Total"
	        worksheet2[1,1] = format("%.2f", @tab_result_facture_encaisse_ttc_ht[0])
		worksheet2[1,2] = format("%.2f", @tab_result_facture_encaisse_ttc_ht[1])

		worksheet1[3,0] = "Par mois"

		compteur_ligne = 4	
		0.upto(@tab_result_facture_encaisse_ttc_ht_by_month.length-1){ |i|
			worksheet2[compteur_ligne, 0] =  month?(i.to_i)
			worksheet2[compteur_ligne, 1] = format("%.2f", @tab_result_facture_encaisse_ttc_ht_by_month[i]["total_facture_ht"])
			worksheet2[compteur_ligne, 2] = format("%.2f", @tab_result_facture_encaisse_ttc_ht_by_month[i]["total_facture_ttc"]) 
			compteur_ligne += 1
		}
		compteur_ligne += 1

		worksheet2[compteur_ligne, 0] = "Par Clients"
		compteur_ligne += 1	
		@hash_name_client_facture_encaisse.each{ |key, value|
			worksheet2[compteur_ligne, 0] = key
			worksheet2[compteur_ligne, 1] = format("%.2f", value["total_facture_ht"])
			worksheet2[compteur_ligne, 2] = format("%.2f", value["total_facture_ttc"])
			compteur_ligne += 1
		}
		rapports_xls.write "#{RAILS_ROOT}/public/rapport_excel/rapport_excel.xls"
	end

	def url_rapport?(request_uri)
		return request_uri == "/rapports" || request_uri.scan(/^(.{1,})?-.{1,}?$/) == "/rapports" ? true : false
	end

	def month?(value)
		["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"][value]
	end

	private
	def order_hash_facture_by_client(hash_client_facture)	
		@tab_facture_name_client = Array.new
		tab_facture_value_client = Array.new

		hash_client_facture.each{ |key, value|
			@tab_facture_name_client.push(key)
			tab_facture_value_client.push(value["total_facture_ht"].to_i)
		}

		for i in 0..tab_facture_value_client.length-1 do
			for e in i..tab_facture_value_client.length-1 do

				if tab_facture_value_client[i] < tab_facture_value_client[e]
					value1 = tab_facture_value_client[i].to_f
					value2 = tab_facture_value_client[e].to_f
					nameclient1 =  @tab_facture_name_client[i]
					nameclient2 = @tab_facture_name_client[e]
					tab_facture_value_client[i] = value2
					tab_facture_value_client[e] = value1	
					Rails.logger.info "tab_facture_value_client[i]-=-=-=-=-=-=-=-#{tab_facture_value_client[i]}-=-=-=-=-=-=-=-tab_facture_value_client[e]-=-=-=-=-=-=-=-=-=-#{tab_facture_value_client[e]}"
					@tab_facture_name_client[i] = nameclient2
					@tab_facture_name_client[e] = nameclient1
				end
			end
		end
		@tab_facture_name_client
	end
end
