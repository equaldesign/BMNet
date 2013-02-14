var map = null;
var markers = [];
var markerClusterer = null;
var infoWindow = new google.maps.InfoWindow();
  function initCharts(){
    
    if (markerClusterer != null) {
      markerClusterer.clearMarkers();
    }
    var mapOptions = {
      zoom: 6,
      center: new google.maps.LatLng(54.2047, -3.6914),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }; 
    map = new google.maps.Map(document.getElementById("googleHeatMap"), mapOptions);
    var image = "/eunify/includes/images/marker.png"; 
    latlngbounds = new google.maps.LatLngBounds();
    var markers = [];

    var markerImage = new google.maps.MarkerImage(image,
      new google.maps.Size(24, 32));
    $("#googleHeatMap").block();
    $.ajax({
      url: "/eunify/sales/chartData?dataType=last30daysbycustomer&filterColumn=" + $("#filterColumn").val() + "&filterValue=" + $("#filterValue").val(),
      dataType: "json",     
      success:function(data) {
        for (var i = 0; i < data.results.length; ++i) {         
          var lat = parseFloat(data.results[i].latitude);
          var lng = parseFloat(data.results[i].longitude);
          if (lat != 0) {
            console.log("done" + lat);
            var point = new google.maps.LatLng(lat,lng);
            var marker = new google.maps.Marker({
              position: point,
              map: map,
              icon: markerImage
            });           
            latlngbounds.extend(point);
            var fn = markerClickFunction(data.results[i], point);
            google.maps.event.addListener(marker, 'click', fn);           
            markers.push(marker);
          }
          
        }
        $("#googleHeatMap").unblock();
        markerClusterer = new MarkerClusterer(map, markers);
        //map.fitBounds(latlngbounds);
      }
    })
     
  }
	
markerClickFunction = function(customer, latlng) {
    return function(e) {
      e.cancelBubble = true;
      e.returnValue = false;
      if (e.stopPropagation) {
        e.stopPropagation();
        e.preventDefault();
      }
      var title = customer.customerName;
      var spend = customer.spend;
      var id = customer.id;
  
      var infoHtml = '<div class="info"><h3><a href="/eunify/customers/detail/id/' + id + '">' + title +
        '</h3><p>&pound' + spend + '</p></a></div>';
  
      infoWindow.setContent(infoHtml);
      infoWindow.setPosition(latlng);
      infoWindow.open(map);
    };
  };
	
$(document).ready(function(){
  initCharts();     
});	