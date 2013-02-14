$(document).ready(function(){
	
	$("#inputStreams .edit").live("click",function(){
		var fID = $(this).attr("rel");
		$("#inputStream").load( $.buildLink("psa.inputStreamEdit","inputStreamID=" + fID));
		$.scrollTo("#inputStream",800);
		return false;
	})
	
	$("#inputStreams .delete").live("click",function(){
		var fID = $(this).attr("rel");
		var row = $(this).parent().parent();
    $.ajax({
			url:  "/eunify/psa/hasFiguresEntry?inputStreamID=" + fID,
			dataType: "json",
			success: function(data) {
				var exists = data.result;
				if (exists) {
					alert("supplier has already entered figures. Cannot delete!");
				} else {
					$.ajax({
						url:  "/eunify/psa/deleteFiguresElement?inputStreamID=" + fID,
						dataType: "json",
						success: function(){
							alert("deleted!");
							$(row).remove();
						}
					})
				}
			}
		})
		return false;
  })
	$("#chainName").autocomplete({
    source:  $.buildLink("chart.psasearch"),
    minLength: 2,
      select: function(event, ui) {
        var series = $(this).attr("id");
        $("#chainDealID").val(ui.item.id);                    
      }
  })
	$("#chainList .delete").live("click",function(){
		var fID = $(this).attr("rel");
		var row = $(this).parent().parent();    
		$("#inputChains").block();
    $.ajax({
      url:  "/eunify/psa/removeChain?chainID=" + fID,
      dataType: "html",
      success: function(){
        $(row).remove();
				$("#inputChains").unblock();
      }
    }) 
    return false;
	})
	$("#inputChains").validate({
    submitHandler: function(form) {
       $("#inputChains").block();
       
        $(form).ajaxSubmit({
        target: "#inputStream",
        success: function(data) {
          $("#inputChains").unblock();
          $("#chainList").html(data);
          $("#inputChains").unblock();
          $.scrollTo("#chainList",800);
          
        }
               
      });     
    } 
  });
	$("#inputS").validate({
    errorClass: "invalid",
    rules: {
      name: "required"
    },
    messages: {
      name: "Figures Title is required!"
    },  
		submitHandler: function(form) {
			 $("#streamList").block();
			 $("#inputStream").block();
			 
			$(form).ajaxSubmit({
				target: "#inputStream",
				success: function() {
					$("#streamList").unblock();
					$("#streamList").load("/eunify/psa/inputStreamList?psaID=" + $("#psaID").val(), function() {
						$("#inputStream").unblock();
						$.scrollTo("#streamList",800);
					});
				}
				       
			});     
		} 
	})
})
