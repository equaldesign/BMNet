$(document).ready(function(){
	$(".productLayout").click(function(event){
		var layout = $(this).attr("rel");
		var destination = $(this).attr("href") + "&l=" + layout;		
		event.preventDefault();		
		$.get("/bv/products/setLayout/layout/" + layout,function(){
			$.address.value(destination);
		})
	})
	$(".deletePrice").click(function(){
		var priceNode = $(this).attr("rel");
		var c = window.confirm("Are you sure you want to delete this priceset?");
		if (c) {
			$.ajax({
				url: "/alfresco/service/api/node/workspace/SpacesStore/" + priceNode + "?alf_ticket=" + $("#alf_ticket").val(),
				type: "DELETE"				
			})	
			$(this).closest("form").parent().remove();	  
	  }
	});
	$(".deleteProduct").click(function(){
		var delURL = $(this).attr("href");
		var sure = window.confirm("Are you sure you want to delete this product!?");
		if (sure) {
			$.ajax({
				url: "/alfresco/service" + delURL,
				type: "DELETE"
			})
			$(this).closest(".productList").fadeOut(function(){
            $(this).remove();
      });
		}
		return false;
	})
	$(".feature").click(function(){
		var e = $(this);
		if ($(e).hasClass("true")) {
			$.ajax({
				url: $(e).attr("href") + "&feature=true",
				type: "POST",
				success: function(){
					$(e).removeClass("true").addClass("false");
				}
			})
		} else {
			$.ajax({
        url: $(e).attr("href") + "&feature=false",
				type: "POST",
        success: function(){
          $(e).removeClass("true").addClass("true");
        }
      })
		}
		return false;
	})
	$(".productImage").mouseenter(function(){
		$(this).find(".refreshProductImage").show();
	})
	$(".productImage").mouseleave(function(){
    $(this).find(".refreshProductImage").hide();
  })
	$(".refreshProductImage").click(function(){
  	var img = $(this).closest(".productImage").children("img");
  	var imgsrc = $(img).attr("src");
  	var imgArray = imgsrc.split("/");
		$(img).attr("src", "/includes/images/secure/imagerefresh.gif");  	  	
  	imgArray.splice(3, 0, "purge");  	
  	newImgURL = imgArray.join("/");  	
		
		$("#dialog").image(newImgURL,function(){
      $(img).attr("src",newImgURL);
			$("#dialog").empty();
    });
  	$.ajax({
			url: newImgURL, 
			success: function(newImgURL){
  		  $(img).attr("src", imgsrc);
  	  },
			error: function(newImgURL){
        $(img).attr("src", imgsrc + "&" + guidGenerator());
      }
		});  
  })
	$(".editProductImage").click(function(event){		
		var url = $(this).attr("href");
		event.preventDefault();
		event.stopPropagation();
		$("dialog").html("");
		$("#dialog").dialog("destroy").dialog({
      modal: true,
      title: "Edit Product Image",
      width: 800,
      height: 600
    });
    $("#dialog").html("<img style='margin-top: 300px; margin-left: 290px' src='/includes/images/secure/ajax-loader.gif' />")
    $.get(url, function(data){
      $("#dialog").html(data);
      $("#dialog").dialog("open");
    });
		return false;
	});
	$(".editProductDocs").click(function(event){    
    var url = $(this).attr("href");
    event.preventDefault();
    event.stopPropagation();
    $("dialog").html("");
    $("#dialog").dialog({
      modal: true,
      title: "Edit Product Documents",
      width: 800,
      height: 600
    });
    $("#dialog").html("<img style='margin-top: 300px; margin-left: 290px' src='/includes/images/secure/ajax-loader.gif' />")
    $.get(url, function(data){
      $("#dialog").html(data);
      $("#dialog").dialog("open");
    });
    return false;
  });
});

function guidGenerator() {
    var S4 = function() {
       return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
    };
    return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
}
$.fn.image = function(src, f){
    return this.each(function(){
      $("<img />").appendTo(this).each(function(){
         this.src = src;
         this.onload = f;
      });
    });
}