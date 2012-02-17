	Position.includeScrollOffsets = true;

	Draggables.clear = function (event) {
		while (Draggables.drags.length) {
			var d = Draggables.drags.pop();
			var e = d.element;
			d.stopScrolling();
			d.destroy();
			d.element = null;
			if (e.parentNode) {e.parentNode.removeChild(e)}; 
		}
	}

	function cleanup() { //try to remove circular references
		lis = document.getElementsByTagName("li");
		for (i = 0; i < lis.length; i++) {
			if (lis[i].longListItem) {
				lis[i].longListItem.destroy();
			}
			else if (lis[i].container) {lis[i].container.destroy();}
		}
		Draggables.clear();
	}

window.onload = function() {

     tab_list_ul_title_information_general = $('id_information_general').getElementsByTagName('ul');
	//var li = $('id_information_general').getElementsByTagName('ul')[0].getElementsByTagName("li");
     for (var e = 0; e < tab_list_ul_title_information_general.length; e++){
	var li = tab_list_ul_title_information_general[e].getElementsByTagName("li");
	 for (var i = 0; i < li.length; i++) {
		//var d = new LongListItem(li[i]);
		//li[i].onmousedown = d.onMouseDown.bindAsEventListener(d);
		var d = new Draggable(li[i], 
		{revert: false,
		 ghosting: true,
		 //scroll: $('id_information_general').getElementsByTagName('ul')[0]
		 scroll: tab_list_ul_title_information_general[e].id 
		});
	}
     }
	 tab_list_ol_informationlignes = $('id_information_general').getElementsByTagName('ol');
	for (var e = 0; e < tab_list_ol_informationlignes.length; e++){
	 var divs = tab_list_ol_informationlignes[e].getElementsByTagName("li");
	   for (i = 0; i < divs.length; i++) {
	     if (divs[i].className && Element.hasClassName(divs[i], "informationligne")) {
		Droppables.add(divs[i].id, {hoverclass: "hover", scrollingParent: divs[i].className,  onDrop: function(dragged, dropped, event){
    			//alert('Dragged: ' + dragged.id);
    			//alert('Dropped onto: ' + dropped.id);
			titleinformationligne_id = dragged.id.split("_")[1];
			informationligne_id = dropped.id.split("_")[1];
			devi_id = $('id_information_general').up().id.split("_")[2]; 

				new Ajax.Request("/javascript/sortable_titleinformationligne_to_informationligne", {
					method: 'post',
					parameters: {devi_id: devi_id, titleinformationligne_id: titleinformationligne_id, informationligne_id: informationligne_id},
					onSuccess: function(transport) {
						if (4 == transport.readyState && 200 <= transport.status && transport.status < 300) {
							//alert(transport.responseText); 
							//contener_titleinformationligne = transport.responseText
							//alert(dropped.getElementsByTagName("ul")[0].id)
							if (transport.responseText == "true"){
								//alert(dragged);
								dragged.setStyle({
									  marginLeft: '40px',
									  marginBottom: '40px;'
								});
i
								height_ul_informationligne_titleinformationligne = parseFloat(dropped.getElementsByTagName("ul")[0].getStyle("height"));
								//alert(height_ul_informationligne_titleinformationligne);
								total_ul_li_informationligne_titleinformationligne = parseFloat(dropped.getElementsByTagName("ul")[0].getElementsByTagName("li").length);	
								//dropped.setStyle({
							      if (height_ul_informationligne_titleinformationligne == 0)
							      {
								height_to_add_ul_informationligne_titleinformationligne = 40;
							      }
							      else {
								taille_add_for_one_li = new Number(parseFloat(height_ul_informationligne_titleinformationligne) / parseFloat(total_ul_li_informationligne_titleinformationligne));
								height_to_add_ul_informationligne_titleinformationligne = new Number(parseFloat(height_ul_informationligne_titleinformationligne) + taille_add_for_one_li);
							      }
								//alert(height_to_add_ul_informationligne_titleinformationligne);	
								//});
								//alert(dropped.getElementsByTagName("ul")[0].getElementsByTagName("li")[0]);
								dropped.getElementsByTagName("ul")[0].setStyle({
									height: height_to_add_ul_informationligne_titleinformationligne + "px",
								});
								new Insertion.Bottom(dropped.getElementsByTagName("ul")[0], dragged);
							}
							else {
							  	alert("Il y a un problème de chargement du titre de cette ligne"); 	
								new Insertion.Bottom(dragged.up(), dragged);
							}
						}		
					},
					onFailure: function(){ 
							  alert("Il y a un problème de chargement du titre de cette ligne"); 	
							  new Insertion.Bottom(dragged.up(), dragged);
					}      
				});
				return false; 
  			}
 		});
	     }
	   }
	}
	Event.observe(window, 'unload', cleanup, false);

}
