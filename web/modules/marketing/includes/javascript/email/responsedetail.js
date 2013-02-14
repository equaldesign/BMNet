var map;
$(function() {
	
	
	
	var mapDiv = $("#gMap");
	$(mapDiv).block();
	mapOptions = {
    zoom: 5,
    center: new google.maps.LatLng("54.00776876193478", "-1.9775390625"),
    mapTypeId: google.maps.MapTypeId.TERRAIN,
    streetViewControl: true,
    mapTypeControl: true
  };
	clickicon = new google.maps.MarkerImage('/modules/marketing/includes/images/markers/click.png',new google.maps.Size(32, 37),new google.maps.Point(0,0),new google.maps.Point(0, 16));
	readicon = new google.maps.MarkerImage('/modules/marketing/includes/images/markers/read.png',new google.maps.Size(32, 37),new google.maps.Point(0,0),new google.maps.Point(0, 16));
	unsubscibeicon = new google.maps.MarkerImage('/modules/marketing/includes/images/markers/unsubscribe.png',new google.maps.Size(32, 37),new google.maps.Point(0,0),new google.maps.Point(0, 16));
  map = new google.maps.Map(document.getElementById($(mapDiv).attr("id")), mapOptions);
	var markerArray = [];
	var overlay = new google.maps.OverlayView();
	overlay.draw = function() {};
	overlay.setMap(map);
	$.ajax({
		url: "/marketing/email/chart/map?campaignID=" + $(mapDiv).attr("campaign-id"),
		success: function(result) {
			var latlngbounds = new google.maps.LatLngBounds();
	    for (var i = 0; i < result.length; i++) {		      
	      var id = result[i].id;		      
				
	      var point = new google.maps.LatLng(parseFloat(result[i].latitude), parseFloat(result[i].longitude));		 					
	      var marker = new google.maps.Marker({
	        position: point,						
	        map: map,
					icon: eval(result[i].icon),
	        title: name,
	        id: result[i].id,						
					html: result[i].html
	      }); 
	      var boxText = document.createElement("div");
				$(boxText).addClass("popover right")
		    boxText.style.cssText = "display:block; width:350px";
		    boxText.innerHTML = '<div class="arrow"></div>' + 
          '<h3 class="popover-title"><a href="/eunify/contact/index/id/' + result[i].id + '">' + result[i].title + '</a></h3>' + 
          '<div class="popover-content">' + 
            result[i].html +  
          '</div>';					
		
		    var myOptions = {
				content: boxText,
				disableAutoPan: false,
				maxWidth: 0,
				pixelOffset: new google.maps.Size(40, -90),
				zIndex: null,
				boxStyle: { 					  
					width: "350px"
				},
				closeBoxMargin: "10px 2px -30px 2px",
				closeBoxURL: "http://www.google.com/intl/en_us/mapfiles/close.gif",
				infoBoxClearance: new google.maps.Size(1, 1),
				isHidden: false,
				pane: "floatPane",
				enableEventPropagation: false
		    };
		
		    google.maps.event.addListener(marker, "click", function (e) {
		      ib.open(map, this);						
		    });
		
		    var ib = new InfoBox(myOptions);			    
				google.maps.event.addListener(map, "idle", function(){
				    marker.setMap(map);
				});
	      latlngbounds.extend(point);
	      markerArray.push(marker);
	    }				
			$(mapDiv).unblock();                
			google.maps.event.trigger(map, 'resize');
      map.setZoom(map.getZoom());        
	    map.fitBounds(latlngbounds);
	    
		}
	})
	$('.nav-tabs a').on('shown', function (e) {
    google.maps.event.trigger(map, 'resize');
    map.setZoom(map.getZoom()); 			
  })	
});

geocoder = new google.maps.Geocoder();
