$(document).ready(function(){
	$(".date").datepicker();

	$("#editPrice").validate({
    errorClass: "invalid",
    rules: {
      security_group: "required"
    },
    messages: {
      name: "You need to select at least one security group"
    },
    submitHandler: function(form) {
			$("#dialog").find(".ui-dialog-content").block();
			
			product = new Object();			
			product.prices = {};			
			$(form).find("input").each(function(){
				if ($(this).attr("name") != "" && $(this).val() != "") {
					if ($(this).attr("type") == "checkbox") {
						if ($(this).is(":checked")) {
						 product.prices[$(this).attr("name")] = $(this).val()	
						}
					} else {
						product.prices[$(this).attr("name")] = $(this).val()
					}			   
		    }
			})
			
      $.ajax({
	      url: $("#editPrice").attr("action"),
	      contentType: "application/json",
	      data: JSON.stringify(product),
	      dataType: "json",
	      type: "POST",
	      success: function (data) {
	        $("#dialog").find(".ui-dialog-content").unblock();
	        $("#dialog").dialog("close");
					document.history.go(0);               
	      }     
      });
			return false;			
    } 
	})
})
