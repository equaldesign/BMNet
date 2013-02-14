var map;
$(document).ready(function(){
	var geocoder = new google.maps.Geocoder();
  var directionsDisplay = new google.maps.DirectionsRenderer();
  var directionsService = new google.maps.DirectionsService();
  var mapOptions = {
    zoom: 11,
    center: new google.maps.LatLng(parseFloat($("#nearestMap").attr("origin").split(",")[0]),parseFloat($("#nearestMap").attr("origin").split(",")[1])),
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    streetViewControl: false
  };
  
  
  var image = "https://d25ke41d0c64z1.cloudfront.net/images/icons/icons-shadowless/pin.png";
  var map = new google.maps.Map(document.getElementById("nearestMap"), mapOptions);  
  
  calcRoute($("#nearestMap").attr("origin"),$("#nearestMap").attr("destination"));
  function calcRoute(destAddress,originAddress) {
    
    var request = {
      origin:originAddress, 
      destination: destAddress,
      travelMode: google.maps.DirectionsTravelMode.DRIVING,
       unitSystem: google.maps.DirectionsUnitSystem.IMPERIAL
    };
    directionsService.route(request, function(result, status) {
      if (status == google.maps.DirectionsStatus.OK) {
        directionsDisplay.setDirections(result);
				$("#mapDirections").html(result.routes[0].legs[0].distance.text + ' / ' + result.routes[0].legs[0].duration.text);
        //showSteps(result);
      }
    });
		directionsDisplay.setMap(map);
		
  }  
})
