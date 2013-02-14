$(document).ready(function(){
	var pbStatus = 0;		
  var siteID = $("#progressBar").attr("rel");
	var thisWin = $("#progressBar").parentsUntil(".ui-tabs-panel").parent();
    var timer = window.setInterval(updateProgress,2000);
    function updateProgress() {
      $("#progressBar").css('width', pbStatus + "%");
      if (pbStatus < 100) {
        $.ajax({ 
         url: "/site/getImportStatus?siteID=" + siteID,
         datatype: "json",
         success: function(data) {
            pbStatus = parseInt(data.STATUS);
						$("#timeUpdated").html(data.STATUS);
            return;
         }
       });
      } else {
        $("#progressBar").hide("slow");
        var links = $("#figs > ul").find("li a");
        var url = $.data(links[0], 'href.tabs');
        var refreshUrl = url + "?fwCache=true";          
        $.ajax({ 
          url:  refreshUrl,
          format: "html",
          success: function(data) {             
            $(thisWin).html(data);             
          }
        });                           
        window.clearInterval(timer);
        return true;
      }
    }      
})
