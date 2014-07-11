/*var currentlyPressedKeys = Object();

function handleKeyDown(event) {
	    currentlyPressedKeys[event.keyCode] = true;
}

function handleKeyUp(event) {
	    currentlyPressedKeys[event.keyCode] = false;
}


  function handleKeys() {
    if (currentlyPressedKeys[13]) {
      // Page Up
      //zoom -= 0.1;
      //alert("test");
      return false;
    }
    if (currentlyPressedKeys[65]) {
      // Page Down
      //zoom += 0.1;
    }
    if (currentlyPressedKeys[38]) {
      // Up cursor key
      //tilt += 2;
    }
    if (currentlyPressedKeys[40]) {
      // Down cursor key
      //tilt -= 2;
    }
  }

function veriftouchkey() {
    document.onkeydown = handleKeyDown;
    document.onkeyup = handleKeyUp;

    setInterval(handleKeys, 15);
}

window.onload = veriftouchkey;
*/
Event.addBehavior({
	'.class_champs_number:change' : function(e) {
		            if (isNaN(this.value) || this.value == "")
				this.value = 0;

			var dif_montant = this.up().up().childElements()[4].innerHTML - parseFloat(this.value) * parseFloat(this.up().up().childElements()[3].down().value) 
			this.up().up().childElements()[4].innerHTML = parseFloat(this.value) * parseInt(this.up().up().childElements()[3].down().value);
		
			this.up().up().up().up().up().up().up().getElementsByTagName("table")[this.up().up().up().up().up().up().up().getElementsByTagName("table").length-1].getElementsByTagName("tr")[0].getElementsByTagName("td")[1].innerHTML = parseFloat(this.up().up().up().up().up().up().up().getElementsByTagName("table")[this.up().up().up().up().up().up().up().getElementsByTagName("table").length-1].getElementsByTagName("tr")[0].getElementsByTagName("td")[1].innerHTML) - parseFloat(dif_montant);
	},

	'.class_champs_price:change' : function(e) {
			if (isNaN(this.value) || this.value == "")
				this.value = 0;
			
			var dif_montant = this.up().up().childElements()[4].innerHTML - parseFloat(this.value) * parseFloat(this.up().up().childElements()[1].down().value) 
			this.up().up().childElements()[4].innerHTML = parseInt(this.value) * parseFloat(this.up().up().childElements()[1].down().value);

			this.up().up().up().up().up().up().up().getElementsByTagName("table")[this.up().up().up().up().up().up().up().getElementsByTagName("table").length-1].getElementsByTagName("tr")[0].getElementsByTagName("td")[1].innerHTML = parseFloat(this.up().up().up().up().up().up().up().getElementsByTagName("table")[this.up().up().up().up().up().up().up().getElementsByTagName("table").length-1].getElementsByTagName("tr")[0].getElementsByTagName("td")[1].innerHTML) - parseFloat(dif_montant);
	},

	'.class_champs_number:keydown' : function(e) {
		//handleKeys();
		//handleKeys();
		if (e.keyCode == 13)
			return false;
	},


	'.class_champs_price:keydown' : function(e) {
		if (e.keyCode == 13)
			return false;
	},

	'.class_champs_price_lignedevi:keydown' : function(e) {
		if (e.keyCode == 13)
			return false;
	},

	'.class_champs_name_lignedevi:keydown' : function(e) {
		if (e.keyCode == 13)
			return false;
	},

	'#facture_datepaiementcheck:click' : function(e) {
		//alert(this.checked);
		this.checked ? $("id_div_datepaiementcheck").show() : $("id_div_datepaiementcheck").hide();
	},

	'#devi_tva:click' : function(e) {
		if (this.checked){
			$('id_tva').style.color = 'black';
			$('id_ttc').style.color = 'black';	
		}
		else{
			$('id_tva').style.color = 'silver';
			$('id_ttc').style.color = 'silver';
		}
	},

	'input.class_champs_price_lignedevi:change' : function(e) {
			if (isNaN(this.value) || this.value == "")
				this.value = 0;
			
			total = parseFloat($('id_total_sum_general').innerHTML.trim()); 
			//alert("test");
			liste_tr_table_total_produit = this.up().up().up().up().getElementsByTagName("tr");
			//alert(liste_tr_table_total_produit[11].id);
			//alert(liste_tr_table_total_produit[6].id);
			var i = 6;
			//var name_first_tr = liste_tr_table_total_produit[6].id; 
			//alert(name_first_tr);
			while (liste_tr_table_total_produit[i].id != null && liste_tr_table_total_produit[i].id.split("_").length > 1)
			{
				//alert(liste_tr_table_total_produit[i].getElementsByTagName("td")[1].childElements()[0].value);
				total += parseFloat(liste_tr_table_total_produit[i].getElementsByTagName("td")[1].childElements()[0].value); 	
				i += 1;
			}
			while (i < liste_tr_table_total_produit.length)
			{
				//if (i != 9)
				//{
					//alert(liste_tr_table_total_produit[i].getElementsByTagName("td")[1].innerHTML);
					if (i == 8)
						liste_tr_table_total_produit[i].getElementsByTagName("td")[1].innerHTML = total;

					if (i == 10)	
						liste_tr_table_total_produit[i].getElementsByTagName("td")[1].innerHTML = parseFloat(total) * (20/100);

					if (i == 11)
						liste_tr_table_total_produit[i].getElementsByTagName("td")[1].innerHTML = parseFloat(total) + (parseFloat(total) * (20/100));
				//}

				i += 1;
			}
	},

	'ul#ul_id_list_facture input:click' : function(e) {
	      if (this.checked)
	      {
		new Ajax.Request("/javascript/calculpvrecettes", {
			method: 'post',
		        parameters: { facture_id: this.value, total_ht: $("id_total_ht").innerHTML, total_ttc: $('id_total_ttc').innerHTML},
		        onSuccess: function(transport) {
				//alert(transport.responseText);
				$('id_total_ht').innerHTML = transport.responseText.split("-")[0];
				$('id_total_ttc').innerHTML = transport.responseText.split("-")[1];
			},
		    	onFailure: function(){ alert("Il y a eu un problème lors du calcul du prix HT et TTC pour cette facture")} 
		});
	      }
	      else
	      {
		list_id_facture = ""
		$$('.class_list_facture').each(function(cb){ 
			if (cb.checked)
			{
				//alert(cb.value);
				list_id_facture += (list_id_facture == "" ? cb.value : "-"+cb.value)
			}
		});
		      new Ajax.Request("/javascript/calculpvrecettestotal", {
		      	method: 'post',
			parameters: {facture_id: list_id_facture},
		        onSuccess: function(transport) {
				//alert(transport.responseText);
				$('id_total_ht').innerHTML = transport.responseText.split("-")[0];
				$('id_total_ttc').innerHTML = transport.responseText.split("-")[1];
			},
		    	onFailure: function(){ alert("Il y a eu un problème lors du calcul du prix HT et TTC pour cette facture")} 
		      });
	      }

	},

        '#check_all_checkbox_factures:click' : function(e) {
    		$$('.class_list_facture').each(function(cb){ cb.checked = e.element().checked });
	},

	'table tr td.class_prices_to_avoir:change' : function(e) {
		if (isNaN(this.down().value) || this.down().value == "")
				this.down().value = 0;

		//this.down().value;
		$("id_price_avoir_total_tva").update(Math.round((parseFloat(this.down().value) * 20)/100));
		$("id_price_avoir_total_ttc").update(Math.round(parseFloat(this.down().value) + (parseFloat(this.down().value) * 20)/100));
	},

	'ul.ul_class_list_facture_bonlivraison li input:click' : function(e) {	
		list_id_facture = ""
		$$('.class_list_facture').each(function(cb){ 
			if (cb.checked)
			{
				//alert(cb.value);
				//alert(cb.value);
				list_id_facture += (list_id_facture == "" ? cb.value : "-"+cb.value)
			}
		});

		//$("facture_16").remove();
		tab_list_information_bonlivraison_facture = new Array();
		tab_list_information_bonlivraison_facture = $("id_tab_list_bonlivraison").getElementsByTagName("tr");
		//for (i = 0; i < tab_list_information_bonlivraison_facture.length; i++)
		//{
			/*if (tab_list_information_bonlivraison_facture[i].id != "id_information_tableau")
			{*/
				//$(tab_list_information_bonlivraison_facture[i]).remove();
			//}

		//}
		$("id_tab_list_bonlivraison").getElementsByTagName("tbody")[1].remove();
		
		new Ajax.Request("/javascript/list_informationlignedevis", {
			method: 'post',
		        parameters : {facture_id: list_id_facture},
		        onSuccess : function(transport) {
			     if (4 == transport.readyState && 200 <= transport.status && transport.status < 300)
			     {
				$("id_tab_list_bonlivraison").insert({
					bottom: transport.responseText
				});
			     }
			},
		    onFailure: function(){ alert("Il y a eu un problème pendant le chargement du dom javascript pour le chargement des informations concernant ces factures")}
		});
	},
});
