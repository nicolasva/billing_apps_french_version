module DevisHelper
	def get_ht(devi)
		totalht = 0
		devi.informationlignes.each{ |informationligne|
			totalht += (informationligne.price.nil? ? 0 : informationligne.price)  * (informationligne.number.nil? ? 0 : informationligne.number)
		}

		devi.lignedevis.each{ |lignedevi|
			totalht += lignedevi.prix
		}
		@total_get_ht += totalht if !@total_get_ht.nil? && devi.etat == 2
		@total_devi_attente += totalht if !@total_get_ht.nil? &&  devi.etat == 1
		totalht
	end

	def get_real_etat(indice)
		["En attente", "Accepté", "Refusé"][indice-1]
	end

	def get_color_etat(indice)
		["#FEF680", "#80E694", "#B4BCBC"][indice-1]
	end

	def array_select_form_font_size_num
		num_array_select_all = Array.new

		0.upto(20){ |i|
			num_array = Array.new
			num_array.push(i.to_f,i.to_f)

			num_array_select_all.push(num_array)
		}

		return num_array_select_all
	end
end
