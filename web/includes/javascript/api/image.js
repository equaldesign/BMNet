$(document).ready(function(){
	$("head").append("<link>");
  css = $("head").children(":last");
  css.attr({
    rel:  "stylesheet",
    type: "text/css",
    href: "https://www.buildingvine.com/includes/style/jQuery/jqzoom.css"
  });
	$.getScript("https://www.buildingvine.com/includes/javascript/jQuery/jqzoom.pack.1.0.1.js",function(){
		$.getScript("https://www.buildingvine.com/includes/javascript/jQuery/jQuery.screenshot.js",function(){
      
			$(".zoom").jqzoom({zoomWidth: 350,
        zoomHeight: 350,
        zoomType:'reverse',
        xOffset: 10,
        yOffset: 0,
        position: "right"});
		  $("a.screenshot").screenshotPreview();  
    })
	})  
});
