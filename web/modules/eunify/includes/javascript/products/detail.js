$(function(){
	$(".delivery_area").livequery("click",function(){
		var inpBox = $(this).closest("div").find(".delivery_extra");
		switch ($(this).val()) {
			case "collectonly":
        $(inpBox).hide();
        break;
			case "nationwide":
        $(inpBox).show().text("exlc. postcodes");
        break;
      case "radius":
			  $(inpBox).show().text("miles");
			  break;
		  case "postcode":
        $(inpBox).show().text("postcodes");
        break;
		}					
	})
	var product_code = $("#product_code").val();
	$("#liveUpdate").find('input[type="text"], select').each(function(){
		var thisElement = this;
		var thisElementParent = $(this).closest("div");
		var attributeName = $(this).attr("name");
		$(this).change(function(){
			$(thisElementParent).append('<i><img hspace="10" src="/includes/images/spinner.gif" border="0" /></i>');
			$.ajax({
	      url: "/eunify/products/setAttribute",
				method: "POST",
				data: {
					attribute: attributeName,
					value: $(thisElement).val(),
					product_code: product_code
				},
	      datatype: "html",
	      success: function(data) {
	        $(thisElementParent).find("i").remove();        
	      }
	    })
		})
	})
	$("#liveUpdate").find('input[type="radio"]').each(function(){
    var thisElement = this;
    var thisElementParent = $(this).closest("label");
    var attributeName = $(this).attr("name");
    $(this).change(function(){
      $(thisElementParent).append('<i><img hspace="10" src="/includes/images/spinner.gif" border="0" /></i>');
      $.ajax({
        url: "/eunify/products/setAttribute",
        method: "POST",
        data: {
          attribute: attributeName,
          value: $(thisElement).val(),
          product_code: product_code
        },
        datatype: "html",
        success: function(data) {
          $(thisElementParent).find("i").remove();        
        }
      })
    })
  })
  $("#liveUpdate").find('input[type="checkbox"]').each(function(){
    var thisElement = this;
    var thisElementParent = $(this).closest("label");
    var attributeName = $(this).attr("name");
    $(this).change(function(){
      $(thisElementParent).append('<i><img hspace="10" src="/includes/images/spinner.gif" border="0" /></i>');
      $.ajax({
        url: "/eunify/products/setAttribute",
        method: "POST",
        data: {
          attribute: attributeName,
          value: $(thisElement).is(":checked"),
          product_code: product_code
        },
        datatype: "html",
        success: function(data) {
          $(thisElementParent).find("i").remove();        
        }
      })
    })
  })
})
