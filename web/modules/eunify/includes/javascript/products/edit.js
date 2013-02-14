	$("#applytoothers").click(function(){
		var x = window.confirm("Are you sure?");
		if (x) {
			$("#editProduct").attr("action","/eunify/products/applyToAll");
			$("#editProduct").ajaxSubmit({
		    success: function(){      		      
		      $("#dialog").dialog("close");
		    }
		  })
		}
	})
