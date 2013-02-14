var map = null;
var markers = [];
var markerClusterer = null;
var infoWindow = new google.maps.InfoWindow();

$(document).ready(function(){ 
	initCharts();			
});


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
    var image = "/modules/eunify/includes/images/marker.png";
    latlngbounds = new google.maps.LatLngBounds();
    var markers = [];

    var markerImage = new google.maps.MarkerImage(image,
      new google.maps.Size(24, 32));
    $("#googleHeatMap").block();
    $.ajax({
      url: "/eunify/sales/chartData?dataType=customerdissapearance&filterColumn=" + $("#filterColumn").val() + "&filterValue=" + $("#filterValue").val(),
      dataType: "json",     
      success:function(data) {
        for (var i = 0; i < data.DATA.length; ++i) {         
          var lat = parseFloat(data.DATA[i][2]);
          var lng = parseFloat(data.DATA[i][3]);
          if (lat != 0) {
            //console.log("done" + lat);
            var point = new google.maps.LatLng(lat,lng);
            var marker = new google.maps.Marker({
              position: point,
              map: map,
              icon: markerImage
            });           
            latlngbounds.extend(point);
            var fn = markerClickFunction(data.DATA[i], point);
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
      var title = customer[0];
      var spend = customer[4];
      var id = customer[1];
  
      var infoHtml = '<div class="info"><h3><a href="/eunify/company/detail/id/' + id + '">' + title +
        '</h3><p>' + spend + ' invoices in last 6 months</p></a></div>';
  
      infoWindow.setContent(infoHtml);
      infoWindow.setPosition(latlng);
      infoWindow.open(map);
    };
  };	