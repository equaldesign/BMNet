var initialLocation;
var siberia = new google.maps.LatLng(60, 105);
var newyork = new google.maps.LatLng(40.69847032728747, -73.9514422416687);
var browserSupportFlag =  new Boolean();
var map;
var infowindow = new google.maps.InfoWindow();
  
$(document).ready(function(){
  // Try W3C Geolocation method (Preferred)
  if(navigator.geolocation) {
    browserSupportFlag = true;
    navigator.geolocation.getCurrentPosition(function(position) {      
			$.get("/user/setCoOrds?&lat=" + position.coords.latitude + "&lng=" + position.coords.longitude);
			console.log(position.coords.latitude); 
    }, function() {
      handleNoGeolocation(browserSupportFlag);
    });
  } else if (google.gears) {
    // Try Google Gears Geolocation
    browserSupportFlag = true;
    var geo = google.gears.factory.create('beta.geolocation');
    geo.getCurrentPosition(function(position) {
      $.get("/user/setCoOrds?&lat=" + position.coords.latitude + "&lng=" + position.coords.longitude);
			console.log(position.coords.latitude);
    }, function() {
      handleNoGeolocation(browserSupportFlag);
    });
  } else {
    // Browser doesn't support Geolocation 
    browserSupportFlag = false;
    handleNoGeolocation(browserSupportFlag);
  }
});
 
function handleNoGeolocation(errorFlag) {
  if (errorFlag == true) {
    initialLocation = newyork;
    contentString = "Error: The Geolocation service failed.";
  } else {
    initialLocation = siberia;
    contentString = "Error: Your browser doesn't support geolocation. Are you in Siberia?";
  }
  
}