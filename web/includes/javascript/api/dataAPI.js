$(document).ready(function() {
  var dataString = $("#bv_extra_data").attr("rel");
	if (dataString != "" && dataString != null) {
	 var apiString = $("#bv_extra_data").attr("rel");
   $.ajax({
	 	 url: "https://www.buildingvine.com/api/getAssociatedDocuments?" + apiString,
		 dataType: "jsonp",
		 success: function(data) {
       $("#bv_docs").append(data.docs);			 
     }
	 })
	  
	}	 
}); 
