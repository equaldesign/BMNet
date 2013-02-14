$(document).ready(function(){
	var treeNodeID = 0;
	if ($("#parentID").val() == 0) {
		treeNodeID = $("#id").val();
	} else {
		treeNodeID = $("#parentID").val();
	}
	var btnDelete = $('.ui-dialog-buttonpane').find('button:contains("Ok")');
	$(btnDelete).find("span").text($("#buttonText").val());
	
	$("#editCategory").ajaxForm({
		success: function(){			
			$("#productTree").jstree("refresh", $("#" + treeNodeID).parent()); 
			$("#dialog").dialog("close");
		}
	})
	$(btnDelete).click(function(){
		$("#editCategory").submit();
	})
	$("#findBVImage").click(function(){
    var theDiv = $('<div id="dialog2"></div>');    
		$("body").append(theDiv);
		mediaSource = $(this).prev().attr("id");  
    sourceType = "input";
    var url = "/bv/documents/getFolder?useAjax=true&siteID=" + $("#siteID").val() + "&folder=web/media";
    $("#dialog2").dialog({
      title: "Insert an image",
      buttons: {},
      width: 700,
      height: 500,
      beforeClose: function(event, ui) { 
        mediaSource = "";
      }
    })
    $.ajax({
      url: url,
      datatype: "html",
      success: function(data) {
        $("#dialog2").html(data);
        $("#dialog2").dialog("open");     
        originalContet =  data;   
      }
    })		
	})
})
