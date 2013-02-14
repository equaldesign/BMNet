$(document).ready(function(){
	$(".insert_image").click(function(){
		mediaSource = $(this).prev().attr("id");  
		sourceType = "input";
    var url = "/bv/documents/getFolder?useAjax=true&siteID=" + $("#siteID").val() + "&folder=web/media";
      $("#dialog").dialog({
        title: "Insert an image",
        buttons: {},
        width: 800,
        height: 500,
				zIndex: $(this).closest(".modal").css("z-index")+1,
        beforeClose: function(event, ui) { 
          mediaSource = "";
        }
      })
    $.ajax({
      url: url,
      datatype: "html",
      success: function(data) {
        $("#dialog").html(data);
        $("#dialog").dialog("open");     
        originalContet =  data;   
      }
    })
	})
})
