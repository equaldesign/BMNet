var markerArray = [];
var sidebar;
var map;
var latlngbounds;
$(document).ready(function() {    
  var outerDiv = $("#stockistMap");
  var siteID = $(outerDiv).attr("rel");
	$("head").append('<link rel="stylesheet" href="https://www.buildingvine.com/includes/styles/public/stockists.css" type="text/css" />');
  var mapOptions = {
    zoom: 11,
    center: new google.maps.LatLng(0, 0),
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    streetViewControl: true
  };  
		$(".windowClose").live("click", function(e){
			$(this).parent().hide();
			e.preventDefault();
			return false;
		})
		$(outerDiv).prepend('<div id="gmap" style="width:' + $(outerDiv).width() + 'px; height:' + $(outerDiv).height() + 'px;"></div><div id="popOverlay"><a href="#" class="noAjax windowClose">close</a><div id="windowContent"></div></div>');
		var image = "https://www.buildingvine.com/includes/images/public/stockist/marker.png";
		var map = new google.maps.Map(document.getElementById("gmap"), mapOptions);
		$.ajax({
			url: "https://www.buildingvine.com/alfresco/service/bv/stockist/list.json?maxRows=1000&siteID=" + siteID + "&guest=true",
			dataType: "jsonp",
			success: function(result){
				latlngbounds = new google.maps.LatLngBounds();
				for (var i = 0; i < result.results.length; i++) {
					var branch = result.results[i];
					var name = branch.name;
					var id = branch.nodeRef;
					var address = branch.address;
					var point = new google.maps.LatLng(parseFloat(branch.attributes.latitude), parseFloat(branch.attributes.longitude));
					var marker = new google.maps.Marker({
						position: point,
						map: map,
						title: name,
						id: id,
						icon: image
					});
					google.maps.event.addListener(marker, 'click', function(){
						var t = this;
						$.ajax({
							url: "https://www.buildingvine.com/alfresco/service/bv/stockist?nodeRef=" + t.id + "&guest=true",
							dataType: "jsonp",
							success: function(result){
								var branchDetail = "";
								if (result.attributes.logoURL != null || result.attributes.logoURL != undefined) {
									branchDetail += '<img class="branchLogo" src="' + decodeURIComponent(result.attributes.logoURL) + '"" />';
								}
								branchDetail += '<h1 class="name">' + result.attributes.companyName + '</h1>';
								branchDetail += '<h2 class="name">' + result.name + '</h2>';
								branchDetail += "<h3>" + result.attributes.address1 + "</h3>";
								branchDetail += "<h3>" + result.attributes.town + "</h3>";
								branchDetail += "<h3>" + result.attributes.county + "</h3>";
								branchDetail += "<h4 class='phone'>" + result.attributes.phone + "</h4>";
								if (result.attributes.email != null || result.attributes.email != undefined) {
									branchDetail += "<h4 class='email'>" + result.attributes.email + "</h4>";
								}
								branchDetail += '<div id="smallMap" style="width: 95%; height: 450px; margin: 10px;"></div>';
								
								$("#windowContent").html(branchDetail);
								$("#popOverlay").show();
							  var smallpoint = new google.maps.LatLng(parseFloat(result.attributes.latitude), parseFloat(result.attributes.longitude));
                var smallMapOptions = {
                  zoom: 17,
                  center: smallpoint,
                  mapTypeId: google.maps.MapTypeId.SATELLITE,
                  streetViewControl: true
                }; 
                var smallMap = new google.maps.Map(document.getElementById("smallMap"), smallMapOptions);
                var smallmarker = new google.maps.Marker({
                  position: smallpoint,
                  map: smallMap,
                  title: result.name,
                  id: result.nodeRef,
                  icon: image
                });						
							}
						})
					});
					latlngbounds.extend(point);
					markerArray.push(marker);
				}
				map.fitBounds(latlngbounds);
			}
		})	
}); 