$(document).ready(function(){
  
	$(".select").click(function(){
		// add the product / category
		var category = false;
		if ($(this).hasClass("category")) {
		  category = true;	
		}
		$.ajax({
			url: "/alfresco/service/bv/promotion/association?alf_ticket=" +  $("#alf_ticket").val(),
			data: {
				nodeRef: $("#promoNodeRef").val(),
				assRef: $(this).attr("rel"),
				category: category
			},
			dataType: "json",
			type:"POST",
			success: function(data) {
				// move the source object
				$(this).remove();
				for (i=0;i<data.length;i++) {
					var n = data[i];
					$("#existingProducts").find("tbody").append('<tr><td><a rel="' + n.nodeRef + '" href="##" class="noAjax deselect"><i class="icon-removeFromList"></i></a></td><td>' + n.title + '</td></tr>');
				}
			}
		})
	})
	$(".deselect").live("click",function(){
		var thisOb = this;
    $.ajax({
      url: "/alfresco/service/bv/promotion/association?alf_ticket=" +  $("#alf_ticket").val() + "&nodeRef=" + $("#promoNodeRef").val() + "&assRef=" + $(this).attr("rel"),
      dataType: "json",
      type:"DELETE",
      success: function() {
        // move the source object
        $(thisOb).parent().parent().remove();        
      }
    })
  })
	
	$("#findProductForAssociation").autocomplete({
    source: function( request, response ) {
      $.ajax({
        url: $("#findProductForAssociation").attr("rev") + "&q=" + $("#findProductForAssociation").val() + "*",     				
        success: function(data) {				  
          response($.map(data.items,function(item) {
            return {
              label: item.title + " "  + item.eancode,
              value: item.nodeRef
            }
          }));
        }
      });
    },    
    delay: 2,
    minLength: 3,
    select: function( event, ui ) {
			
      $.ajax({
	      url: "/alfresco/service/bv/promotion/association?alf_ticket=" +  $("#alf_ticket").val(),
	      data: {
	        nodeRef: $("#promoNodeRef").val(),
	        assRef: ui.item.value,
	        category: false
	      },
	      dataType: "json",
	      type:"POST",
	      success: function(data) {
	        // move the source object
	        $("#findProductForAssociation").val("");	     
	        $("#existingProducts").find("tbody").append('<tr><td><a rel="' + ui.item.value + '" href="##" class="noAjax deselect"><i class="icon-removeFromList"></i></a></td><td>' + ui.item.label + '</td></tr>');	        
	      }
	    })
	    
    }
  })
})
