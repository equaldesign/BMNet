$(document).ready(function(){
  $(".date").datepicker({
		dateFormat: 'yy-mm-dd'
	});
	$("#editPromotion").submit(function(){        	  
    var nodeRef = $("#nodeRef").val();
		var title = $("#title").val();
		var description = $("#description").val();
		var code = $("#code").val();
		var validFrom = $("#validFrom").val();
		var validTo = $("#validTo").val();
		var siteID = $("#siteID").val();
		var uri =$("#editPromotion").attr("action"); 
		$("#dialog").html('<img src="/includes/images/secure/ajax-loader.gif" style="postion:relative;margin-top:200px:margin-left:50px" />');      
    $.ajax({
      url: uri,      
      data: {
        nodeRef: nodeRef,
        title:title,
        description: description,
        code: code,
        validFrom: validFrom,
        validTo: validTo,
        siteID: siteID
      },
      dataType: "json",
      type: "POST",
      success: function (data) {
				
				$("#dialog").load("/promotions/editassociations?nodeRef=" + data.nodeRef,function(){
					$(".ui-dialog-title").text("2. Choose Related Products");
					$("#editProductAssociations").submit(function(){
						var uri =$(this).attr("action"); 
						$("#dialog").html('<img src="/includes/images/secure/ajax-loader.gif" style="postion:relative;margin-top:200px:margin-left:50px" />');
				    $.ajax({
				      url: uri, 
				      success: function(data) {
				        $("#dialog").html(data);
								$(".ui-dialog-title").text("3. Upload Files");   
				        $(".ui-dialog-buttonpane").find('button:contains("Save")').remove();  
				        var doneButt = $(".ui-dialog-buttonpane").find('button:contains("Cancel")');
				        $(doneButt).text("Done");
				        $(doneButt).click(function(){
				          $("#dialog").dialog("close");
				          $.blockUI();
				          window.history.go(0);
				        })
				      }
				    })
				    return false;
				  })
				});   
      }     
    }); 
    return false;   
  });	
	
})
