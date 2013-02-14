$(document).ready(function() {
	$(".map_canvas").each(function(){
		var latitude = $(this).attr("rel");
		var longitude = $(this).attr("rev");
		doMap($(this).attr("id"),latitude,longitude);
	})
	var options = {
      target:        '#rightPanel',   // target element(s) to be updated with server response
      url:       $("#editBranch").attr("action") + $.buildLink("","layout=ajax")        // override for form's 'action' attribute
      //type:      type        // 'get' or 'post', override for form's 'method' attribute
      //dataType:  null        // 'xml', 'script', or 'json' (expected server response type)
      //clearForm: true        // clear all form fields after successful submit
      //resetForm: true        // reset the form after successful submit

      // $.ajax options can be used here too, for example:
      //timeout:   3000
  };
	
	$(".deleteBranch").click(function(){
		var branchID = $(this).attr("rel");
		var branchDiv = $(this).parents(".branchDiv");
		$(branchDiv).block();
		$.ajax({
			url: $.buildLink("branch.delete"),
			data: {
				id: branchID
			},			
			method: "POST",
			success: function(data) {
				$(branchDiv).unblock();
				$(branchDiv).fadeOut(
					"slow",
					function (){
						$(this).remove();
					}
				)
			}
		})
	})
  $("#editBranch").ajaxForm(options);	
	$(".addBranch").click(function(){
		var companyID = $(this).attr("rel");
		$(".branchScreen").block();
		$.ajax({
			url: $.buildLink("branch.edit"),
			method: "POST",
			data: {
				companyID: companyID
			},
			success: function(data) {
				$(".branchScreen").html(data);
				$(".branchScreen").unblock();
			}
		})
	})
})

function doMap(mapDiv,lt,ln) {
	var latitude = lt;	
	var longitude = ln;
	var center = new google.maps.LatLng(latitude, longitude);
	var mapOptions = {
		zoom: 11,
		center: center,
		streetViewControl: true,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	};
	var map = new google.maps.Map(document.getElementById(mapDiv), mapOptions);

var marker = new google.maps.Marker({
      position: center, 
      map: map
  	});	

}

