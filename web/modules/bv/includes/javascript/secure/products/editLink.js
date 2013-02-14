$(function(){
	$("#addLink").click(function(){
		// add a new link.
		var productNode = $("#productNode").val();
		var linkName = $("#newLinkName").val();
		var linkRef = $("#newLinkRef").val();
		var linkType = $("#newLinkType").val();
		$.ajax({
        url: $("#theLinkForm").attr("action"),
				data: {
					productNode: productNode,
					linkName: linkName,
					linkAddress: linkRef,
					linkType: linkType
				},
        type: "POST",
				success: function(data) {
					$("#current").append('<div class="control-group">' + 
            '<label class="control-label" for="title">' + linkName + '</label>' +
            '<div class="controls">' +
              '<div class="input-append">' +
                '<input class="input-medium" type="text" name="name" value="' + linkRef + '" />' +
                '<select class="input-small" name="linkType">' +
                  '<option value="youTube">YouTube</option>' +
                  '<option value="webpage">WebPage</option>' +
                  '<option value="tweet">Tweet</option>' +
                '</select>' +
                '<span class="add-on">' +
                  '<a data-id="' + data.nodeRef + '" href="##" class="deleteLink"><i class="icon-delete"></i></a>' +
                  '<a data-id="' + data.nodeRef + '" href="##" class="saveLink"><i class="icon-save"></i></a>' +
                '</span>' +
              '</div>' +
            '</div>' +
          '</div>');
				}        
      })  		
	})
	$(".saveLink").live("click",function(){
		var thisRow = $(this).closest(".controls");
		var thisRef = $(thisRow).find("input").val();
		var thisType = $(thisRow).find("select").val();
		var thisNode = $(this).attr("data-id");
		$.ajax({
        url: $("#theLinkForm").attr("action"),
        data: {
          linkNode: thisNode,          
          linkAddress: thisRef,
          linkType: thisType
        },
        type: "POST",
        success: function(data) {
          // console.log("do something nice");
        }        
      })
	})
	$(".deleteLink").live("click",function(){		
		var thisNode = $(this).attr("data-id");
		var thisRow = $(this).closest(".controls");
		$.ajax({
        url: $("#theLinkForm").attr("action") + "&linkNode=" + thisNode,        
        type: "DELETE",
        success: function(data) {
          // console.log("do something nice");
					$(thisRow).remove();
        }        
      })
	})
})
