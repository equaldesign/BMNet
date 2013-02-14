$(document).ready(function(){
  $("#feedM").show();
  $("#rightMenuAccordion").accordion("destroy").accordion({ 
    icons: false, 
    navigation: true,     
    autoHeight: false, 
    collapsible: true, 
    header: 'h3'
  });  
	$(".optOut").click(function(){
		var optOutURL = $(this).attr("href");
		var attr = $(this).attr('rev');
		var jsonObject = new Object();		
		if (typeof attr !== 'undefined' && attr !== false) {
		    jsonObject.appToolId = attr;
		}
		jsonObject.siteId = $(this).attr("rel");		
		$.ajax({
			url: optOutURL,
      contentType: "application/json",
      data: JSON.stringify(jsonObject),
      dataType: "json",
      type: "POST"
		})
		$(this).closest(".article").remove();
		return false;
	})
	$(".docTip").tooltip({
		track: true,
		delay:0,
		showURL: false,
		bodyHandler: function() {
			var documentRel = $(this).attr("rel").split("_");
			var documentID = documentRel[1];
			var siteID = documentRel[0];
			return $("<img/>").attr("src","/eunify/includes/images/thumbnails/" + siteID + "/" + documentID + ".jpg");
		}
	})
})
