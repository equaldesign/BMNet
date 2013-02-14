$(document).ready(function(){
  var container = $("#bvFrame");	
	if (container != null) {
  	var w = $(container).width();  	
  	var uri = $(container).attr("rel");
  	
  	
  	src = 'http://connect.buildingvine.com/products/index/siteID/' + uri + '/#' + encodeURIComponent(document.location.href);
  	iframe = $('<iframe src="' + src + '" width="' + w + '" height="500" scrolling="no" frameborder="0"><\/iframe>').appendTo('#bvFrame');
  	$.receiveMessage(function(e){
  		var h = e.data.split("=")[1];
  		$("#bvFrame iframe").height(h);
  		$("#bvFrame iframe").attr("height", h);  		
  	}, 'http://connect.buildingvine.com');
  }
});