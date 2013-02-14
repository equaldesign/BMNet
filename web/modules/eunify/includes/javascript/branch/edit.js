$().ready(function() {
	var geocoder = new google.maps.Geocoder();
	doBigMap();
	$("#editBranch").validate({
		errorClass: "invalid",
		rules: {
			name: "required",
			known_as: "required",
			default_contact_firstname: "required",
			default_contact_surname: "required",
			default_contact_email: {
	  		required: true,
	  		email: true
	  	}
		},
		messages: {
			name: "Company Name is required",
			known_as: "Known As is required",
			default_contact_firstname: "We need a contact first name",
			default_contact_surname: "We need a contact surname",
			default_contact_email: {
				required: "We need a valid email address",
				email: "This doesn't appear valid"
			}
		}
	})
	$("#CoOrdinates").live("click",function(){
		var postCode = $("#postcode").val();
		$.ajax({
			url: $.buildLink("branch.getCoOrdinates"),
			dataType: "json",
			data: {
				postCode: $("#postcode").val(),
				address1: $("#address1").val(),
				town: $("#town").val()
			},
			success: function(data) {
				$("#maplat").val(data.latitude);
				$("#maplong").val(data.longitude);
				doBigMap();
			}
		})
	})
	function doBigMap() {
		var latitude = $("#maplat").val();	
		var longitude = $("#maplong").val();
		var center = new google.maps.LatLng(latitude, longitude);
		var mapOptions = {
			zoom: 15,
			center: center,
			mapTypeId: google.maps.MapTypeId.ROADMAP,
			streetViewControl: true
		};
		var map = new google.maps.Map(document.getElementById("googleMap"), mapOptions);
		var marker = new google.maps.Marker({
	      position: center, 
				draggable: true,
	      map: map
	  });
		google.maps.event.addListener(marker, 'dragend', function() {
	    updateMarkerPosition(marker.getPosition());
	  });
	}
	function geocodePosition(pos) {
	  geocoder.geocode({
	    latLng: pos
	  }, function(responses) {
	    if (responses && responses.length > 0) {
				$("#addressInfo").html(responses[0].formatted_address);
	    } else {
	      $("#addressInfo").html('Cannot determine address at this location.');
	    }
	  });
	}
	function updateMarkerPosition(latLng) {
		geocodePosition(latLng);
	  $("#maplat").val(latLng.lat());
		$("#maplong").val(latLng.lng());
	}
});