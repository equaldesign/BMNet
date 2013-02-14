$(document).ready(function(){
  var destAddress = $("#mapOverview").attr("data-destination");
  var originAddress = $("#mapOverview").attr("data-origin");
  var geocoder = new google.maps.Geocoder();
  var directionsDisplay = new google.maps.DirectionsRenderer();
  var directionsService = new google.maps.DirectionsService();
  var mapOptions = {
    zoom: 11,
    center: new google.maps.LatLng(0, 0),
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    streetViewControl: true
  };
  var image = "https://d25ke41d0c64z1.cloudfront.net/images/icons//icons-shadowless/pin.png";
  var map = new google.maps.Map(document.getElementById("mapOverview"), mapOptions);  
  geocoder.geocode({
      "address": destAddress
    }, function(results){
      if (results && results.length > 0) {
        var center = results[0].geometry.location
        var marker = new google.maps.Marker({
          position: center,
          map: map
        });
        map.setZoom(13);
        map.setCenter(center);
      }
    });
  //  
  calcRoute(destAddress,originAddress);
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
        showSteps(result);
      }
    });
  }
  $(".showRoute").live("click",function(){
    directionsDisplay.setMap(map);
    
  })
  $("#recalc").live("click",function(){
    var destAddress = $("#a_address").val();
    var originAddress = $("#u_address").val();  
    calcRoute(destAddress,originAddress);
    directionsDisplay.setMap(map);
    $.scrollTo($("#mapOverview"), 800 );
  })
})

function showSteps(directionResults) {
  var myRoute = directionResults.routes[0].legs[0];
  $("#instructions").empty();
  $("#overview").html("<p class='distance'>" + directionResults.routes[0].legs[0].duration.text + " / " + directionResults.routes[0].legs[0].distance.text + " | <a href='#' rev='instructions' class='show'>show route</a></p>");
  for (var i = 0; i < myRoute.steps.length; i++) {
      $("#instructions").append("<li class='direction'>" + myRoute.steps[i].instructions + " <span class='info'>(for " + myRoute.steps[i].distance.text + " or " +  myRoute.steps[i].duration.text  + ")</span></li>")
      
  }
}