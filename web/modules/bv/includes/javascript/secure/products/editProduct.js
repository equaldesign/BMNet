$(document).ready(function(){
	$(".removeAttribute").live("click",function(){		
		$(this).closest("div.control-group").remove();
		return false;
	})
	$(".date").datepicker({
    dateFormat: 'yy-mm-dd'
  });
	$(".addAttribute").live("click",function(){		
		var key = $(this).closest("div").find("#key").val();
		var value = $(this).closest("div").find("#value").val();
		$('#cloneKey').clone().prependTo('#customKeyPairs').attr("id","custom_" + key).show().find("input").attr("name","custom_" + key).addClass("customerKeyPair").val(value);
		$('#custom_' + key).find("label").attr("for","custom_" + key).text(key);		
	})
	$("#editProduct").submit(function(){              
    var jsonObject = new Object();    
    jsonObject.nodeRef = $("#nodeRef").val();
		jsonObject.title = $("#title").val();
    jsonObject.eancode = $("#eancode").val();
		jsonObject.productactive = $("#productactive").is(":checked");
		jsonObject.autosearch = $("#autosearch").is(":checked");
		jsonObject.manufacturerproductcode = $("#manufacturerproductcode").val();
		jsonObject.supplierproductcode = $("#supplierproductcode").val();
		jsonObject.productdescription = $("#productdescription").val();
		jsonObject.rrp = $("#rrp").val();
		jsonObject.unitweight = $("#unitweight").val();
		jsonObject.manufacturerbrandname = $("#manufacturerbrandname").val();
		jsonObject.customProperties = {};
		$(".customKeyPair").each(function(){
			var key = $(this).attr("id").split("_");
			var keyR = key[1];
			jsonObject.customProperties[keyR] = $(this).val();
		})  		
    $.ajax({
      url: $("#editProduct").attr("action"),
      contentType: "application/json",
      data: JSON.stringify(jsonObject),
      dataType: "json",
      type: "PUT",
      success: function (data) {
				$("#dialog").dialog("close");
        window.history.go(0);                      
      }     
    }); 
    return false;   
  });
})