var map;
geocoder = new google.maps.Geocoder();
var infoWindow = "";
$(function() {
  var mapDiv = $("#gMap");
  $(mapDiv).block();
  mapOptions = {
    zoom: 5,
    center: new google.maps.LatLng("54.00776876193478", "-1.9775390625"),
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    streetViewControl: true,
    mapTypeControl: true
  };
  standardicon = new google.maps.MarkerImage('/modules/marketing/includes/images/markers/click.png',new google.maps.Size(32, 37),new google.maps.Point(0,0),new google.maps.Point(0, 16));
  readicon = new google.maps.MarkerImage('/modules/marketing/includes/images/markers/read.png',new google.maps.Size(32, 37),new google.maps.Point(0,0),new google.maps.Point(0, 16));
  unsubscibeicon = new google.maps.MarkerImage('/modules/marketing/includes/images/markers/unsubscribe.png',new google.maps.Size(32, 37),new google.maps.Point(0,0),new google.maps.Point(0, 16));
  map = new google.maps.Map(document.getElementById($(mapDiv).attr("id")), mapOptions);
  var markerArray = [];
  var overlay = new google.maps.OverlayView();
  overlay.draw = function() {};
  overlay.setMap(map);
	var latlngbounds = new google.maps.LatLngBounds();
  $(".branch").each(function(){
		  var currentBranch = $(this);
      console.log("Attributte" + $(this).text());      
			var result = {};  
      geocoder.geocode({
      "address": $(this).find(".branch_postcode").text()
	    }, function(results){
	      if (results && results.length > 0) {
	        var point = results[0].geometry.location
	        var marker = new google.maps.Marker({
	          position: point,
	          map: map,
						icon: standardicon,
		        title: $(currentBranch).find(".branchName").text()						
	        });	    
					var boxText = document.createElement("div");
		      $(boxText).addClass("popover right")
		      boxText.style.cssText = "display:block; width:350px";
		      boxText.innerHTML = '<div class="arrow"></div>' + 
		        '<h3 class="popover-title"><a href="/html/' + $(currentBranch).find(".fileName").text() + '">' + $(currentBranch).find(".branchName").text()   + '</a></h3>' + 
		        '<div class="popover-content">' + 
		          $(currentBranch).find(".branchDetail").html() +  
		        '</div>';         
		  
		      var myOptions = {
		        content: boxText,
		        disableAutoPan: false,
		        maxWidth: 0,
		        pixelOffset: new google.maps.Size(40, -150),
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
						if (infoWindow != "") {
							infoWindow.close();
						}
						infoWindow = ib;
						ib.open(map, this);           
		      });
		  
		      var ib = new InfoBox(myOptions);          
		      google.maps.event.addListener(map, "idle", function(){
		          marker.setMap(map);
		      });
		      latlngbounds.extend(point);
		      markerArray.push(marker);    
					map.fitBounds(latlngbounds);
	      }
	    });           
  });
	$(mapDiv).unblock();                
  map.fitBounds(latlngbounds); 
});

