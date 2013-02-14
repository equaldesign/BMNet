$(document).ready(function(){
  var assType = $("#assoc_type").val(); 
  $("#q_auto" ).autocomplete({
    source: function( request, response ) {
      $.ajax({
        url: $("#findProducts").attr("action") + "&q=" + $("#q_auto").val() + "*",        
        success: function( data ) {
          response( $.map( data.items, function( item ) {
            return {
              label: item.title + " "  + item.eancode,
              value: item.nodeRef
            }
          }));
        }
      });
    },    
    delay: 1,
    minLength: 3,
    select: function( event, ui ) {
      $("#relationships").append('<li><a class="del" href="/alfresco/service/bv/product/document/associations?nodeRef=' + $("#rel_nodeRef").val() + '&associationType=' + assType + '&assocNode=' + ui.item.value + $("#alf_ticket").val() + '"></a> ' + ui.item.label + '</li>');
      $.ajax({
	      url: '/alfresco/service/bv/product/document/associations?nodeRef=' + $("#rel_nodeRef").val() + '&associationType=' + assType + '&assocNode=' + ui.item.value  + "&alf_ticket=" + $("#alf_ticket").val(),
	      type: "POST",
	      success: function(){        	                
	        removes();
	      }
      })
      return false;
    }
  })
   removes();
})
function removes() {
	$(".del").click(function(){
		var el = $(this);
		$.ajax({
			url: $(this).attr("href"),
			type: "DELETE",
			success: function(){
				$(el).closest("li").remove();				
			}
		})
		return false;
	})
}
