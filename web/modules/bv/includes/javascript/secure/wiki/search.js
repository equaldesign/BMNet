$(document).ready(function(){
	  $("#wikisearch").submit(function(){
			$(".wikipage").block();
			$.ajax({
				url: $(this).attr("action"),
				dataType: "html",
				type:"POST",
				data: {
					query: $("#wikiQ").val()
				},
				success: function(data) {
				  $(".wikipage").unblock();
          $(".wikipage").html(data);	
				}
			})
			return false;
		}) 
})
