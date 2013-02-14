$(function(){
	
	var urltoken = $("#urltoken").val();
  var alf_ticket = $("#alf_ticket").val();
  $("#fupload").uploadify({
    uploader: "/includes/javascript/jQuery/jQuery.upload/uploadify.swf",
    script: "/alfresco/service/api/upload?alf_ticket=" + $("#alf_ticket").val(),
    method: "POST", 
    scriptData: {
      'destination' : $("#folderNodeRef").val()
    },
    auto: true,
    multi: true,   
    hideButton: true,
    wmode: 'transparent',     
    buttonText: "Upload File",    
    width: 100,
    cancelImg: "https://d25ke41d0c64z1.cloudfront.net/images/icons/cross-circle-frame.png",
    height: 16,
    queueID: 'uploadQueue',           
    onComplete: function() {
      var nodeRef = $("#folderNodeRef").val();
       $.get("/documents/documentList?dir=" + nodeRef, function(data){         
          $("#whiteBox").html(data);
          $("#whiteBox").unblock();
      }); 
    }
  });		
	
	$("#mainProductImage").droppable();
	$("#imageResults");
  
	$(".choose").livequery("click",function() {
		chooseImage($(this).closest("div.chooseImage"));
		return false;
	});
	$(".unchoose").livequery("click",function() {
		var item = $(this).closest(".chooseImage");		
    var target = $(this).closest("ul").attr("id");
		var imageNodeRef = $(item).find("img").attr("id");
    var productNodeRef = $("#productNodeRef").val();
		console.log(item);
    $(item).fadeOut(function(){
      // now get rid of the image
      $.ajax({
        url: "/alfresco/service/bv/product/image?association=" + target + "&alf_ticket=" + $("#alf_ticket").val() + "&imageNodeRef=" + imageNodeRef + "&productNodeRef=" + productNodeRef,
        type: "DELETE"				
      })
    })
    return false;
	});
	function chooseImage(item) {
		// if main image is empty, add to main
		if ($("#mainProductImage").find("div.chooseImage").length == 0) {
			var target = $("#mainProductImage");		
			var association = "mainProductImage";	
		} else {
			var target = $("#productImage");
			var association = "productImage";
		}
		var imageNodeRef = $(item).find("img").attr("id");
		var productNodeRef = $("#productNodeRef").val();
		$(item).fadeOut(function(){
			// now add the image
			$.ajax({
				url: "/alfresco/service/bv/product/image?association=" + association + "&alf_ticket=" + $("#alf_ticket").val() + "&imageNodeRef=" + imageNodeRef + "&productNodeRef=" + productNodeRef,
				type: "PUT",
				success: function(){
					if (association == "mainProductImage") {
						$("#productImagePreview").attr("src","https://www.buildingvine.com/api/productImage?nodeRef=" + imageNodeRef + "&size=medium");
					}
					$(item).appendTo($(target)).fadeIn().find(".choose").removeClass("choose").addClass("unchoose").closest("div.chooseImage").find("img");
				}
			})
		})
				
	}
	
	$('#searchImage').ajaxForm({
    data: {                
        doRedirect: false,
        size: "small"
    },
    beforeSubmit: function() {
      $("#imageResults").empty();
      $("#imageResults").block();

    },
    type: "GET",
    success: function(data) {
      $("#imageResults").unblock();       
      $("#imageResults").append("<h5>" + data.length + " results found</h5>");
      for (var i in data) {
          var image = data[i];          
          var htm = '<li><div class="thumbnail chooseImage left">'          
          htm+='<img class="ttip" title="' + image.name + '" id="' + image.node.split("/")[3] + '" src="https://www.buildingvine.com/api/productImage?nodeRef=' + image.node.split("/")[3] + '&size=50" />'
          htm+='<div class="caption">'
          htm+='<a target="_blank" class="icon magnify" href="/alfresco/service/' + image.contentUrl + '?alf_ticket=' + $("#alf_ticket").val() + '"><i class="icon-magnify"></i></a>'
          htm+='<a class="icon choose" href="#"><i class="icon-tick"></i></a>'
          htm+='</div>'
          htm+='</div></li>'
          $("#imageResults").append(htm);
        }   
    }
  });
	
})
