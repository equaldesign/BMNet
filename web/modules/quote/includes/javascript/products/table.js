$(document).ready(function(){
var oTable;
var giRedraw = false;


	
	 oTable =  $('#productList').dataTable( {
        "sDom": "<'widget-header'<'pull-left padd5'l><'pull-right padd5'f>r><'widget-content't><'widget-footer'<'pull-left padd5'i><'pull-right padd5'p>>",
        "sPaginationType": "bootstrap",
        "oLanguage": {
          "sLengthMenu": "_MENU_ records per page",
					"sEmptyTable": "Hmmm. No products matched your search. <strong>Don't panic!</strong> You can manually add them below."
        },
				"bProcessing": true,        			
				"bSort": false,	
				"iDisplayLength": 10,        
        "bStateSave": true				
    } );
  $(".modalProduct").live("click",function(){
		var thisWin = $("#productDetailModal").find(".modal-body");
		$(thisWin).html('<img src="/includes/images/loading.gif" />');
		$.ajax({
			url: $(this).attr("href"),
			success: function(data){
				$(thisWin).html(data);
			}
		})
	})
})