var markerArray = [];
var sidebar;
var map;
$(document).ready(function() {
  infowindow = new google.maps.InfoWindow({
    content: "holding..."
  });
  lightsidemarkerimage = new google.maps.MarkerImage('http://new.cemco.co.uk/includes/images/website/lightsidemarker.png',new google.maps.Size(23, 29),new google.maps.Point(0,0),new google.maps.Point(0, 11));
  heavysidemarkerimage = new google.maps.MarkerImage('http://new.cemco.co.uk/includes/images/website/heavysidemarker.png',new google.maps.Size(23, 29),new google.maps.Point(0,0),new google.maps.Point(0, 11));
  bothmarkerimage = new google.maps.MarkerImage('http://new.cemco.co.uk/includes/images/website/bothmarkerimage.png',new google.maps.Size(23, 29),new google.maps.Point(0,0),new google.maps.Point(0, 11));     
  timbermarkerimage = new google.maps.MarkerImage('http://new.cemco.co.uk/includes/images/website/timbermarker.png',new google.maps.Size(23, 29),new google.maps.Point(0,0),new google.maps.Point(0, 11));      
  markershadow = new google.maps.MarkerImage('http://new.cemco.co.uk/includes/images/website/markershadow.png',new google.maps.Size(38, 29),new google.maps.Point(0,0),new google.maps.Point(0, 11));
  var mapOptions = {
    zoom: 11,
    center: new google.maps.LatLng(0, 0),
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    streetViewControl: true
  };
  var companyID = $("#branchLocatorMap").attr("rel");
    var image = "http://new.cemco.co.uk/images/icons/icons-shadowless/pin.png";
    var map = new google.maps.Map(document.getElementById("branchLocatorMap"), mapOptions);
    $.jsonp({
		  url: "http://new.cemco.co.uk/branch/getAllJSON/companyID/" + companyID + "?type=application/javascript",
			callbackParameter: "callback",
		  context: document.body,
			error: function(xOptions,textStatus) {
				alert(textStatus);
			},
		  success: function(data) {
		    var latlngbounds = new google.maps.LatLngBounds();
        for (var i = 0; i < data.length; i++) {
          var name = data[i].name;
          alert(name); 
          var id = data[i].id;
          var address = data[i].address1;
          var point = new google.maps.LatLng(parseFloat(data[i].latitude), parseFloat(data[i].longitude));
          var htmlString = '<table border="0">' +
          '<tr>' +
          '<td valign="top" class="maptd" colspan="2">' +
          '<strong>' +
          data[i].name +
          '</strong>' +
          '</td>' +
          '</tr>' +
          '<tr>' +
          '<td colspan="2" valign="top" class="maptd">' +
          data[i].address1 +
          " " +
          data[i].address2 +
          '<br />' +
          data[i].town +
          '</td>' +
          '</tr>' +
          '<tr>' +
          '<td valign="top" class="maptd">' +
          'Tel:' +
          '</td>' +
          '<td valign="top" class="maptd">' +
          data[i].tel +
          '</td>' +
          '</tr>' +
          '<tr>' +
          '<td valign="top" class="maptd">' +
          'Email' +
          '</td>' +
          '<td valign="top" class="maptd">' +
          '<a href="mailto:' +
          data[i].email +
          '"><img src="/images/icons/mail.png" border="0" /></a>' +
          '</td>' +
          '</tr>' +
          '</table>';
          var marker = new google.maps.Marker({
            position: point,
            map: map,
            title: name,
            icon: eval(data[i].producttypes),
            shadow: markershadow,
            html: htmlString
          });
          google.maps.event.addListener(marker, 'click', function(){
            infowindow.setContent(this.html);
            infowindow.open(map, this);
          });
          latlngbounds.extend(point);
          markerArray.push(marker);
        }
        map.fitBounds(latlngbounds);
      }
		  
		});
		/*
		$.ajax({
      url: "http://new.cemco.co.uk/branch/getAllJSON/companyID/" + companyID, 
      dataType: "jsonp",
      success: function (data){
        
        var latlngbounds = new google.maps.LatLngBounds();
        for (var i = 0; i < data.length; i++) {
          var name = data[i].name;
          alert(name); 
          var id = data[i].id;
          var address = data[i].address1;
          var point = new google.maps.LatLng(parseFloat(data[i].latitude), parseFloat(data[i].longitude));
          var htmlString = '<table border="0">' +
          '<tr>' +
          '<td valign="top" class="maptd" colspan="2">' +
          '<strong>' +
          data[i].name +
          '</strong>' +
          '</td>' +
          '</tr>' +
          '<tr>' +
          '<td colspan="2" valign="top" class="maptd">' +
          data[i].address1 +
          " " +
          data[i].address2 +
          '<br />' +
          data[i].town +
          '</td>' +
          '</tr>' +
          '<tr>' +
          '<td valign="top" class="maptd">' +
          'Tel:' +
          '</td>' +
          '<td valign="top" class="maptd">' +
          data[i].tel +
          '</td>' +
          '</tr>' +
          '<tr>' +
          '<td valign="top" class="maptd">' +
          'Email' +
          '</td>' +
          '<td valign="top" class="maptd">' +
          '<a href="mailto:' +
          data[i].email +
          '"><img src="/images/icons/mail.png" border="0" /></a>' +
          '</td>' +
          '</tr>' +
          '</table>';
          var marker = new google.maps.Marker({
            position: point,
            map: map,
            title: name,
            icon: eval(data[i].producttypes),
            shadow: markershadow,
            html: htmlString
          });
          google.maps.event.addListener(marker, 'click', function(){
            infowindow.setContent(this.html);
            infowindow.open(map, this);
          });
          latlngbounds.extend(point);
          markerArray.push(marker);
        }
        map.fitBounds(latlngbounds);
      }
    }) 
    */     
})
