$(document).ready(function(){
	
	var urltoken = $("#urltoken").val();
  var alf_ticket = $("#alf_ticket").val();
  $("#fupload").uploadify({
    uploader: "/includes/javascript/jQuery/jQuery.upload/uploadify.swf",
    script: "/alfresco/service/api/upload?alf_ticket=" + $("#alf_ticket").val(),
    method: "POST",
    scriptData: {			
			"siteid": $("#siteID").val(),
			"containerid": "documentLibrary",
			"uploaddirectory": "Product Information"
    },
    auto: true,
    multi: true,   
    wmode: "transparent",     
    hideButton: true,
    width: 85,
    cancelImg: "https://d25ke41d0c64z1.cloudfront.net/images/icons/cross-circle-frame.png",
    height: 30,
    queueID: "uploadQueue",           
    onComplete: function(event, ID, fileObj, response, data) {
			var document = $.parseJSON(response);			
      var htm = '<div class="chooseDocument left">'          
      htm+='<img alt="' + document.name + '" id="' + document.nodeRef.split("/")[3] + '" src="https://www.buildingvine.com/api/productImage?nodeRef=' + document.id + 'small" width="75" />'
      htm+='<div>'
      htm+='<a target="_blank" class="icon magnify" href="/alfresco/service/api/node/content/' + document.nodeRef.replace(":/","") + '/' + document.fileName + '?alf_ticket=' + $("#alf_ticket").val() + '"></a>'
      htm+='<a class="icon choose" href="#"></a>'
      htm+='</div>'
      htm+='</div>'
      $("#documentResults").append(htm);      
    }
  });
	
	$("label.over").labelOver("over");
	$("#mainProductDocument").droppable();
	$("#documentResults");
  
	$(".choose").live("click",function() {
		chooseDocument($(this).closest("div.chooseDocument"));
		return false;
	});
	$(".unchoose").live("click",function() {
		var item = $(this).closest(".chooseDocument");		
    var target = $(this).closest(".documentSelection");
    $(item).fadeOut(function(){
      // now add the document
      $.ajax({
        url: "/alfresco/service/bv/product/document?association=" + $(target).attr("id") + "&alf_ticket=" + $("#alf_ticket").val() + "&documentNodeRef=" + $(item).find("img").attr("id") + "&productNodeRef=" + $("#documentSearch").attr("rel"),
        type: "DELETE",
        success: function(){
					$(item).find("img").attr("width",75);
					$(item).appendTo("#documentResults").fadeIn();
					$(item).removeClass("unchoose").addClass("choose");
        }
      })
    })
    return false;
	});
	function chooseDocument(item) {
		// if main document is empty, add to main		
			var target = $("#productDocument");		
		$(item).fadeOut(function(){
			// now add the document
			$.ajax({
				url: "/alfresco/service/bv/product/document?association=" + $(target).attr("id") + "&alf_ticket=" + $("#alf_ticket").val() + "&documentNodeRef=" + $(item).find("img").attr("id") + "&productNodeRef=" + $("#documentSearch").attr("rel"),
				type: "PUT",
				success: function(){
					$(item).appendTo($(target)).fadeIn().find(".choose").removeClass("choose").addClass("unchoose").closest("div.chooseDocument").find("img").attr("width",50);
				}
			})
		}) 
				
	}
	
	
	$("#searchDocument").submit(function(){
		$("#documentResults").html('<img src="/includes/images/secure/ajax-loader.gif" />');
		$.ajax({
			url: "/alfresco/service/bvine/search/documents.json?maxrows=50&site=" + $("#siteID").val() + "&alf_ticket=" + $("#alf_ticket").val(),
			data: {
				term: $("#docQ").val()
			},
			dataType: "json",			
			success: function(data) {
				$("#documentResults").empty();
				$("#documentResults").append("<h5>" + data.resultCount + " results found</h5>");
				for (var i in data.items) {
					var document = data.items[i];					
					var htm = '<div class="chooseDocument left">'					
					htm+='<img class="ttip" title="' + document.name + '" id="' + document.nodeRef.split("/")[3] + '" src="https://www.buildingvine.com/api/productImage?nodeRef=' + document.nodeRef.split("/")[3]  + '&size=small" width="75" />'
					htm+='<div>'
				
					htm+='<a class="icon choose" href="#"></a>'
					htm+='</div>'
					htm+='</div>'
					$("#documentResults").append(htm);
				}							
			}
		})
		return false;
	})
})
